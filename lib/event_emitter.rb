require_relative "./event_emitter/version"
require_relative "./event_emitter/emitters/generic"
require_relative "./event_emitter/emitters/kinesis"
require_relative "./event_emitter/emitters/rabbitmq"
require_relative "./event_emitter/emitters/error_handler"
require_relative "./event_emitter/emitters/message_builder"
require_relative "./event_emitter/emitters/publisher"
require_relative "./event_emitter/emitters/config"

class EventEmitter

  def self.config
    @config ||= Emitters::Config.new
  end

  def self.configure(&config_options)
    yield config
  end

  def self.push(data)
    return unless event_emission_enabled?

    validate!(data)

    handle_exceptions(data) do
      backend.publish(message: message.to_json, options: data, config: config)
    end
  end

  # private_class_method :event_emission_enabled?, :backend

  def self.event_emission_enabled?
    config.emission_enabled
  end

  def self.backend
    case config.backend
    when :kinesis
      Emitters::Kinesis
    when :rabbitmq
      Emitters::RabbitMQ
    else
      fail "Unsupported backend: #{config.backend}"
    end
  end

  def self.validate!(data)
    fail "No entity" unless data[:entity_name]
    fail "No object" unless data[:object]
    fail "No operation" unless data[:operation]
  end

  def self.message
    Emitter::MessageBuilder.build(data)
  end

  def self.handle_exceptions(params, &_block)
    EventEmitters::ErrorHandler.handle_exception(entity_name: data[:entity_name],
                                                    object: data[:object].inspect,
                                                    operation: data[:operation],
                                                    backtrace: data[:backtrace],
                                                    raise_errors: @raise_errors) { yield }
  end
end
