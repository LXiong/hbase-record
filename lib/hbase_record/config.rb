module HbaseRecord
  module Config
    extend ActiveSupport::Concern

    included do
      cattr_accessor :connection_configuration, :instance_writer => false
      @@connection_configuration = {}
    end

    module ClassMethods
      @@connection = nil

      def connection
        if @@connection.blank?
          @@connection = if !connection_configuration.empty?
                          HbaseRecord::Connection.new(connection_configuration)
                        elsif defined? ::Rails
                          HbaseRecord::Wrapper::Base.connection
                        else
                          raise ConnectionConfigurationMissing
                        end

          @@connection.open
        end
        @@connection
      end

      def reset_connection!
        @@connection = nil
      end


      def table
        HbaseRecord::Table.new(connection, table_name)
      end

      def table_exists?
        connection.tables.include?(table_name)
      end
    end
  end
end