require_relative "./event_emitter/config"
require_relative "./event_emitter/error"
require_relative "./event_emitter/message_builder"
require_relative "./event_emitter/version"
require_relative "./event_emitter/emitters/generic"
require_relative "./event_emitter/emitters/kinesis"
require_relative "./event_emitter/emitters/rabbitmq"

class EventEmitter

  def self.push(entity_name:, object:, operation:, backtrace:)
    return unless config.emission_enabled?

    backend.publish(
      message: Emitters::MessageBuilder.build(operation: operation, backtrace: backtrace, message: object).to_json,
      options: {
        entity_name: entity_name,
        object: object,
        operation: operation,
        backtrace: backtrace,
      },
      config: config,
    )
  end

  def self.backend
    case config.backend
    when :kinesis
      Emitters::Kinesis
    when :rabbitmq
      Emitters::RabbitMQ
    else
      fail Emitters::Error, "Unsupported backend: #{config.backend}"
    end
  end

  def self.config
    @config ||= Emitters::Config.new
  end

  def self.configure
    yield config
  end

  private_class_method :backend
end
