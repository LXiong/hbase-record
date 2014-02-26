module HbaseRecord
  module Retrieve
    extend ActiveSupport::Concern

    included do
      class << self
        delegate :get, :limit, :scan, :columns, :to => :finder_scope
      end
    end

    module ClassMethods
      def finder_scope
        Scope.new(self)
      end
    end
  end
end