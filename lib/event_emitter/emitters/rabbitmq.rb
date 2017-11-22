require "sneakers"

module Emitters
  class RabbitMQ < Generic

    def initialize(options: {})
      @publisher = Sneakers::Publisher.new(options)
    end

    def publish(message:, options:)
      @publisher.publish(message, options)
    end

  end
end
