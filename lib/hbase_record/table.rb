module HbaseRecord
  module Table
    extend ActiveSupport::Concern
    included do

      class_attribute :table_name_overriden, :instance_writer => false
      self.table_name_overriden = nil
    end


    module ClassMethods
      def table_name
        puts "xxx"
        puts table_name_overriden
        @table_name ||= self.table_name_overriden || self.name.tableize
      end

      def table_name=(table_name)
        self.table_name_overriden = table_name
      end
    end

  end

end