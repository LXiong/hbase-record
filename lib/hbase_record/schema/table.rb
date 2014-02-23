module HbaseRecord
  module Schema
    module Table
      extend ActiveSupport::Concern

      module ClassMethods
        def column_family(name, &block)
          column_families[name]
        end

        def column_families
          @column_families ||= {}
        end
      end

    end
  end
end