require "sneakers"

module Emitters
  class RabbitMQ < Generic

    def self.publish(message:, options:)
      Sneakers::Publisher.new(options).publish(message, options)
    end
  end
end
