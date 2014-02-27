require 'hbase_record/thrift/hbase_types'
require 'hbase_record/thrift/hbase_constants'
require 'hbase_record/thrift/hbase'
require 'hbase_record/schema/table'

module HbaseRecord
  class Base
    include ActiveModel::Conversion

    include HbaseRecord::Schema::Table

    include HbaseRecord::Config
    include HbaseRecord::Finder
    include HbaseRecord::Mutation
    include HbaseRecord::Table
  end
end