module Emitters
  module MessageBuilder
    require "securerandom"
    extend self

    def build(operation, backtrace, message)
      {
        meta: {
          message_uuid: SecureRandom.uuid,
          message_created_at: Time.now.utc.to_s,
          message_operation: operation,
          message_backtrace: backtrace,
        },
        message: message
      }
    end
  end
end
