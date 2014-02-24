module HbaseRecord
  class Cell
    def initialize(tcell)
      @tcell = tcell
    end

    def tcell
      @tcell
    end

    def value
      string
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

    def to_s
      value.to_s
    end

    def inspect
      value
    end
  end
end