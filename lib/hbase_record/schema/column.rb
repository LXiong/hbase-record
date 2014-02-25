module HbaseRecord
  module Schema
    class Column
      def columns
        @columns ||= {}
      end

      def column(name, type=nil, &block)
        if type
          columns[name] = Field.new(type)
        elsif block
          columns[name] = Column.new
          columns[name].instance_eval(&block)
        end
      end
    end
  end
end