module HbaseRecord
  class Cell
    def initialize(tcell, field)
      @tcell = tcell
      @field = field
    end

    def tcell
      @tcell
    end

    def value
      if [:string, :bigdecimal, :int, :short, :float, :long].include? @field.try(:type)
        send @field.type
      else
        tcell
      end
    end

    def timestamp
      tcell.timestamp
    end

    def string
      tcell.value
    end

    def int
    end

    def short
      tcell.value.unpack("s>*").first
    end

    def bigdecimal
      tcell.value.unpack("l>*").first
    end

    def float
      tcell.value.unpack("G*").first
    end

    def long
      tcell.value.unpack("q>").first
    end

    def boolean
      tcell.value.unpack("b").first
    end

    def to_s
      value.to_s
    end

    def inspect
      value
    end

    def method_missing(method, *args)
      value.send(method, *args)
    end
  end
end
