module HbaseRecord
  module Schema
    module Table
      extend ActiveSupport::Concern

      module ClassMethods
        def column_family(name, &block)
          column_families[name] = Schema::Column.new
          column_families[name].instance_eval(&block)
        end

        def column_families
          @column_families ||= {}
        end

        def schema(qualifier)
          keys = qualifier.split(':').map(&:to_sym)

          column = column_families[keys.shift]

          keys.each do |key|
            return nil if column.nil?
            columns = column.columns
            column = columns[key] || columns[columns.keys.select{|k| k.is_a? Regexp }.find{|k| k.match(keys.first)}]
          end
          column
        end
      end

    end
  end
end
