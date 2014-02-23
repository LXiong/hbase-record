module HbaseRecord
  class Scope

    delegate :find, :last, :all, :select, :limit, :starts_with, :offset, :to => :finder_scope

    def initialize(klass)
      @klass = klass
    end

    def get(id)
      Row.new(@klass, getRowWithColumns(@klass.table_name, id.to_s, [], {}).first)
    end

    def method_missing(method, *args)
      @klass.connection.client.send(method, *args)
    end

  end
end