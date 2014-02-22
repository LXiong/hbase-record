module HbaseRecord
  module Wrapper
    class Base

      def self.config
        config = YAML.load_file(::Rails.root.join('config', 'hbase.yml'))[::Rails.env]
        {
          :host => config['host'],
          :hosts => config['hosts'],
          :port => config['port'],
          :timeout => config['timeout']
        }
      end

      def self.connection(opts = {})
        conn = HbaseRecord::Connection.new(opts.empty? ? config : opts)
        conn.open
        conn
      end

    end
  end
end