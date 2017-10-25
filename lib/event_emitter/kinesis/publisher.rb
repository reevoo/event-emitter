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
        data: to_s(payload),
        stream_name: stream.name,
        partition_key: partition_key,
      )
    end

    def put_records
      client.put_records(
        records: payload.map do |record|
          {
            data: to_s(record),
            partition_key: partition_key,
          }
        end,
        stream_name: stream.name,
      )
    end

    private

    def partition_key
      options[:partition_key] || "partition_key"
    end

    def to_s(message)
      return message if message.is_a?(String)

      message.to_json
    end
  end
end
