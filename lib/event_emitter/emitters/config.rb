module Emitters
  class Config

    attr_accessor :backend, :amqp, :vhost, :exchange, :exchange_type, :durable, :ack, :raise_errors, :logger

    def to_hash
      [
        :backend,
        :amqp,
        :vhost,
        :exchange,
        :exchange_type,
        :durable,
        :ack,
        :raise_errors,
        :logger
      ].each_with_object({}) { |attr, memo| memo[attr] = send(attr) }
    end
  end
end
