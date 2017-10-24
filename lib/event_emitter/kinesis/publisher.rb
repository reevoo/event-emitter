module EventEmitter
  module Kinesis
    class Publisher

      attr_reader :payload, :options, :client, :stream

      def initialize(payload:, options:, client:, stream:)
        @payload = payload
        @options = options
        @client = client
        @stream = stream
      end

      def put_record
        client.put_record(
          data: payload,
          stream_name: stream.name,
          partition_key: options[:partition_key] || 'partition_key',
        )
      end

      def put_records
        client.put_records(
          records: payload.map do |record|
            {
              data: record,
              partition_key: options[:partition_key] || 'partition_key',
            }
          end,
          stream_name: stream.name,
        )
      end
    end
  end
end