require "sneakers"

class RabbitMQEmitter < GenericEmitter

  def initialize(options: {})
    @publisher = Sneakers::Publisher.new(options)
  end

  def publish(message:, options:)
    @publisher.publish(message, options)
  end

end
