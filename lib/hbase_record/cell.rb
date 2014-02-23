module HbaseRecord
  class Cell
    def initialize(tcell)
      @tcell = tcell
    end

    def tcell
      @tcell
    end

    def method_missing(method, *args)
      tcell.send(method, *args)
    end

    def string
      value
    end

    def int
    end

    def short
      value.unpack("s>*").first
    end
  end
end