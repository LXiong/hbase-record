module HbaseRecord
  module Mutation
    extend ActiveSupport::Concern

    module ClassMethods
      def put(id, hash)
        mutations = flatten_hash(hash).map { |h|
          column = h[:key].join(":")
          value = case schema(column).try(:type)
            when :string
              h[:val].to_s
            when :bigdecimal
              [h[:val]].pack("l>")
            when :short
              [h[:val]].pack("n")
            when :float
              [h[:val]].pack("G")
            when :long
              [h[:val]].pack("q>")
            when :boolean
              [h[:val]].pack("b")
          end
          Apache::Hadoop::Hbase::Thrift::Mutation.new(column: column, value: value.force_encoding('utf-8'))
        }
        connection.mutateRow(table_name, id, mutations, {})
        true
      end

      def delete(id, hash)
        mutations = flatten_hash(hash).map { |h|
          column = h[:key].join(":")
          Apache::Hadoop::Hbase::Thrift::Mutation.new(isDelete: true, column: column)
        }
        connection.mutateRow(table_name, id, mutations, {})
        true
      end

      def flatten_hash(hash)
        recursive_traverse = Proc.new { |k, v|
          a = if v.is_a?(Hash) then
                v.map(&recursive_traverse).flatten
              else [{key: [], val: v}]
            end
          a.map{ |e|
            {
              key: e[:key].unshift(k),
              val: e[:val]
            }
          }
        }
        hash.map(&recursive_traverse).flatten
      end
    end
  end
end