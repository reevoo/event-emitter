require_relative "./event_emitter/version"
require_relative "./event_emitter/emitters/generic"
require_relative "./event_emitter/emitters/kinesis"
require_relative "./event_emitter/emitters/rabbitmq"

class EventEmitter

  attr_reader :backend

  def initialize(backend: :rabbitmq, options: {})
    @backend = case backend
               when :kinesis
                 Emitters::Kinesis
               when :rabbitmq
                 Emitters::RabbitMQ.new(options: options)
               end
  end

  def publish(message:, options:)
    return unless ENV.fetch("EVENT_EMISSION_ENABLED", "false") == "true"

    backend.publish(message: message, options: options)
  end
end
