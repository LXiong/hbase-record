module HbaseRecord
  class Scope
    SINGLE_VALUE_METHODS = %w(limit project)

    attr_accessor *MULTI_VALUE_METHODS.collect { |m| m + "_values" }
    attr_accessor *SINGLE_VALUE_METHODS.collect { |m| m + "_value" }
    attr_accessor :extra_finder_options
    delegate :limit, :project, :to => :finder_scope
    delegate :inspect, :first, :last, :count, :to => :evaluate

    def initialize(klass)
      @klass = klass
      @extra_finder_options = {}
      self.project_value = {start_row: ''}
    end

    def get(id)
      Row.new(@klass, getRowWithColumns(@klass.table_name, id.to_s, [], {}).first)
    end

    def scan(*args)
      options = args.extract_options!.to_options
      if options.any?
        apply_finder_options(options).scan(*args)
      else
        self
      end
    end

    def limit(limit)
      cloned_version_with { self.limit_value = limit }
    end

    def project(project)
      if not [[:start_row], [:start_row, :stop_row], [:prefix]].include? project.keys
        raise Exception.new 'Project Exception'
      end
      cloned_version_with { self.project_value = project }
    end

    def method_missing(method, *args)
      @klass.connection.client.send(method, *args)
    end

    private

    def evaluate
      case self.project_value.keys
      when [:start_row]
        scanner = scannerOpen(@klass.table_name, self.project_value[:start_row], [], {})
      when [:start_row, :stop_row]
        scanner = scannerOpenWithStop(@klass.table_name, self.project_value[:start_row], self.project_value[:stop_row], [], {})
      when [:prefix]
        scanner = scannerOpen(@klass.table_name, self.project_value[:prefix], [], {})
      end

      rows = []
      if self.limit_value
        self.limit_value.times do
          if trow = scannerGet(scanner).first
            rows << Row.new(@klass, trow)
          else
            break
          end
        end
      else
        loop do
          if trow = scannerGet(scanner).first
            rows << Row.new(@klass, trow)
          else
            break
          end
        end
      end
      rows
    end

    def cloned_version_with(&block)
      clone.tap { |scope| scope.instance_eval(&block) }
    end

    def apply_finder_options(options)
      scope = clone
      return scope if options.empty?

      options.each do |scope_method, arguments|
        if respond_to? scope_method
          scope = scope.send(scope_method, arguments)
        else
          scope.extra_finder_options[scope_method] = arguments
        end
      end

      scope
    end

  end
end