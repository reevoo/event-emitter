require "sneakers"

module Emitters
  class RabbitMQ < Generic

    def self.publish(message:, options:, config:)
      queue = queue_name(options: options, config: config)
      routing_key = queue
      options = { to_queue: queue, routing_key: routing_key}

      @sneakers ||= Sneakers::Publisher.new(options)
      @sneakers.publish(message, options)
    end

    def self.queue_name(options:, config:)
      queue_name = "#{options[:entity_name]}_events_queue"
      queue_name = "#{config.queue_name_prefix}_#{queue_name}" if config.queue_name_prefix
      queue_name
    end

    private_class_method :queue_name
  end
end
