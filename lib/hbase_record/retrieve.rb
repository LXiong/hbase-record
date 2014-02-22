module HbaseRecord
  module Retrieve
    extend ActiveSupport::Concern

    included do
      class << self
        delegate :find, :last, :all, :select, :limit, :starts_with, :offset, :to => :finder_scope
      end
    end

    module ClassMethods
      def finder_scope
        puts "xxx"
      end
    end
  end
end