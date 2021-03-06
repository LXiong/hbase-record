module HbaseRecord
  class Cell
    def initialize(tcell, field)
      @tcell = tcell
      @field = field
    end

    def tcell
      @tcell
    end

    def inspect
      if [:string, :bigdecimal, :short, :float, :long, :boolean].include? @field.try(:type)
        send @field.type
      else
        string
      end
    end

    def timestamp
      tcell.timestamp
    end

    def string
      tcell.value
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
      tcell.value.unpack("b").first == "1"
    end

    def to_s
      inspect.to_s
    end

    def method_missing(method, *args)
      inspect.send(method, *args)
    end
  end
end
