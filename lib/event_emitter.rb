require_relative "./event_emitter/version"
require_relative "./event_emitter/generic_emitter"
require_relative "./event_emitter/kinesis_emitter"

class EventEmitter

  attr_reader :backend

  def initialize(backend)
    @backend = case backend
               when :kinesis
                 KinesisEmitter
               end
  end

  def publish(message:, options:)
    return unless ENV.fetch("EVENT_EMISSION_ENABLED", "false") == "true"

    backend.publish(message: message, options: options)
  end
end
