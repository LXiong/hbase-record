require 'hbase_record/thrift/hbase_types'
require 'hbase_record/thrift/hbase_constants'
require 'hbase_record/thrift/hbase'

module HbaseRecord
  class Base
    include ActiveModel::Conversion

    include HbaseRecord::Schema::Table


    include HbaseRecord::Config
    include HbaseRecord::Retrieve
    include HbaseRecord::Table

    class_attribute :table_name_overriden, :instance_writer => false
    self.table_name_overriden = nil

    class << self

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