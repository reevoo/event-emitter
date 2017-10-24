require_relative "./kinesis/publisher"
require_relative "./kinesis/stream"
require 'aws-sdk'

module EventEmitter
  module Kinesis
    # Requires environment variables set:
    #
    # - ENV['AWS_ACCESS_KEY_ID']
    # - ENV['AWS_SECRET_ACCESS_KEY']
    # - ENV['AWS_REGION']

    def self.publish(payload, options)
      @payload = payload
      @options = options

      if payload.is_a?(Array)
        publisher.put_records
      else
        publisher.put_record
      end
    end

    def self.publisher
      EventEmitter::Kinesis::Publisher.new(payload: @payload, options: @options, client: client, stream: stream)
    end
    private_class_method :publisher

    def self.stream
      EventEmitter::Kinesis::Stream.new(client: client, options: @options)
    end
    private_class_method :stream

    def self.client
      Aws::Kinesis::Client.new
    end
    private_class_method :client
  end
end
