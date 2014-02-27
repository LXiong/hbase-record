module HbaseRecord
  class Scope
    MULTI_VALUE_METHODS = %w(column)
    SINGLE_VALUE_METHODS = %w(limit scan)

    attr_accessor *MULTI_VALUE_METHODS.collect { |m| m + "_values" }
    attr_accessor *SINGLE_VALUE_METHODS.collect { |m| m + "_value" }
    attr_accessor :extra_finder_options
    delegate :inspect, :first, :last, :count, :to_a, :each, :to => :evaluate

    def initialize(klass)
      @klass = klass
      @extra_finder_options = {}
      @scan_value = {start_row: ''}
      @column_values = []
    end

    def get(id)
      trow = getRowWithColumns(@klass.table_name, id.to_s, @column_values, {}).first
      if trow
        Row.new(@klass, trow)
      else
        nil
      end
    end

    def limit(limit)
      cloned_version_with { self.limit_value = limit }
    end

    def scan(scan)
      if not [[:start_row], [:start_row, :stop_row], [:prefix]].include? scan.keys
        raise Exception.new 'Scan Exception'
      end
      cloned_version_with { self.scan_value = scan }
    end

    def columns(*columns)
      columns.map!(&:to_s)
      cloned_version_with { self.column_values.push(*columns) }
    end

    def method_missing(method, *args)
      @klass.connection.send(method, *args)
    end

    private

    def evaluate
      case self.scan_value.keys
      when [:start_row]
        scanner = scannerOpen(@klass.table_name, self.scan_value[:start_row], @column_values, {})
      when [:start_row, :stop_row]
        scanner = scannerOpenWithStop(@klass.table_name, self.scan_value[:start_row], self.scan_value[:stop_row], @column_values, {})
      when [:prefix]
        scanner = scannerOpen(@klass.table_name, self.scan_value[:prefix], @column_values, {})
      end

      rows = []
      if self.limit_value and self.limit_value > 0
        loop do
          break if self.limit_value <= 0
          nb_rows = [256, self.limit_value].min
          count = scannerGetList(scanner, nb_rows).each do |trow|
            rows << Row.new(@klass, trow)
          end.count
          self.limit_value -= count
          break if count < nb_rows
        end
      else
        loop do
          nb_rows = 256
          count = scannerGetList(scanner, nb_rows).each do |trow|
            rows << Row.new(@klass, trow)
          end.count
          break if count < nb_rows
        end
      end
      rows
    rescue IOError => e
      puts 'ioerrer exception!!'
      puts e
      []
    end

    def cloned_version_with(&block)
      clone.tap { |scope| scope.instance_eval(&block) }
    end
  end
end