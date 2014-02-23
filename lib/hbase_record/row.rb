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
      @columns ||= Columns.new( Hash[ @trow.columns.map{ |key, value| [key, Cell.new(value)] } ] )
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
  end
end