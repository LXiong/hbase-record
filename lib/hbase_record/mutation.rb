module HbaseRecord
  module Mutation
    extend ActiveSupport::Concern

    module ClassMethods
      def put(id, val)
        @id = id
        @val = val
        connection.client.mutateRow(table_name, id, mutations, {})
        true
      end

      def mutations
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

        mutations = @val.map(&recursive_traverse).flatten.map { |h|
          column = h[:key].join(":")
          value = case get_type(column)
          when :bigdecimal
            h[:val].to_s
          when :string
            h[:val].to_s
          when :short
            [h[:val]].pack("n")
          end

          Apache::Hadoop::Hbase::Thrift::Mutation.new(column: column, value: value)
        }
      end
    end
  end
end