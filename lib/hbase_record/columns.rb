module HbaseRecord
  class Columns
    delegate :string, :int, :short, :value, :to => :cell, allow_nil: true

    def initialize(raw)
      @raw = raw
      parse
    end

    def parse
      @columns = {}
      @raw.each do |key, cell|
        qualifier, token = key ? key.split(":", 2).map(&:presence) : []
        if qualifier
          @columns[qualifier.to_sym] ||= {}
          @columns[qualifier.to_sym][token] = cell
        else
          @columns[nil] = cell
        end
      end

      @columns.each do |key, column|
        if key
          @columns[key] = Columns.new(column)
          create_method(key) { @columns[key] }
        end
      end
    end

    def create_method(name, &block)
      self.class.send(:define_method, name, &block)
    end

    def [](key)
      @columns[key] || @raw[key]
    end

    def to_h
      @columns
    end

    def cell
      @columns[nil]
    end
  end
end
