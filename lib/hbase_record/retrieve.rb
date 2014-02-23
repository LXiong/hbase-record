module HbaseRecord
  module Retrieve
    extend ActiveSupport::Concern

    included do
      class << self
        delegate :get, :to => :finder_scope
      end
    end

    module ClassMethods
      def finder_scope
        puts "xxx"
        Scope.new(self)
      end
    end
  end
end