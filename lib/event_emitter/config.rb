module Emitters
  class Config

    attr_accessor :backend, :amqp, :vhost, :exchange, :exchange_type, :durable, :ack,
      :emission_enabled, :queue_name_prefix

    def to_hash
      %i[
        backend
        amqp
        vhost
        exchange
        exchange_type
        durable
        ack
        emission_enabled
        queue_name_prefix
      ].each_with_object({}) { |attr, memo| memo[attr] = send(attr) }
    end

    def emission_enabled?
      emission_enabled == true
    end
  end
end
