require_relative "./kinesis/publisher"
require_relative "./kinesis/stream"
require "aws-sdk"

module Emitters
  class Kinesis < Generic
    # Requires environment variables set:
    #
    # - ENV['AWS_ACCESS_KEY_ID']
    # - ENV['AWS_SECRET_ACCESS_KEY']
    # - ENV['AWS_REGION']

    def self.publish(message:, options:, config:)
      @message = message
      @options = options
      @_config = config

      message.is_a?(Array) ? publisher.put_records : publisher.put_record
    end

    def self.publisher
      KinesisPublisher.new(message: @message, options: @options, client: client, stream: stream)
    end

    def self.stream
      KinesisStream.new(client: client, options: @options)
    end

    def self.client
      Aws::Kinesis::Client.new
    end

    private_class_method :publisher, :stream, :client
  end
end
