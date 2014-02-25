module HbaseRecord
  module Schema
    class Field
      def initialize(type)
        @type = type
      end

      def type
        @type
      end
    end
  end
end