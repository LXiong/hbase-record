module HbaseRecord
  class Row

    def initialize(klass, trow)
      @klass = klass
      @trow = trow
    end

    def key
      @trow.row
    end

    def columns
      @columns ||= Columns.new(
        Hash[@trow.columns.map{ |key, value|
          [
            key,
            Cell.new(value, @klass.schema(key)).value
          ]
        }]
      )
    end

    def to_h
      columns.to_h
    end

    def [](key)
      columns[key]
    end

    def method_missing(method, *args)
      columns.send(method, *args)
    end

    # private

    # def schema(key, value)
    #   key.split(':').map(&:to_sym)
    #   schema = column_families[key.first]
    #   key.
    # end

    # def column_families
    #   @klass.column_families
    # end
  end
end