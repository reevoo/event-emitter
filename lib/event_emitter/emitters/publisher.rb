# module Emitters
#   class Publisher

#     def initialize(raise_errors: false)
#       @client = emitter_client
#       @raise_errors = raise_errors
#     end

#     def emit_event(params)
#       fail "No entity" unless params[:entity_name]
#       fail "No object" unless params[:object]
#       fail "No operation" unless params[:operation]

#       handle_exceptions(params) do
#         @client.publish(message: message(params).to_json,
#                         options: {
#                           to_queue: "#{params[:entity_name]}_events_queue",
#                           routing_key: "#{params[:entity_name]}_events_queue",
#                         })

#         update_emitted_at_timestamp(params[:object])
#       end
#     end

#     private

#     def message(params)
#       EventEmitters::MessageBuilder.build(entity_name: params[:entity_name],
#                                           object: params[:object],
#                                           operation: params[:operation],
#                                           backtrace: params[:backtrace])
#     end

#     def handle_exceptions(params, &_block)
#       EventEmitters::ErrorHandler.handle_exception(entity_name: params[:entity_name],
#                                                     object: params[:object].inspect,
#                                                     operation: params[:operation],
#                                                     backtrace: params[:backtrace],
#                                                     raise_errors: @raise_errors) { yield }
#     end

#     def emitter_client
#       EventEmitter.new(backend: :rabbitmq, options: {
#                           amqp: ENV["EVENT_EMITTER_AMQP"],
#                           vhost: ENV["EVENT_EMITTER_VHOST"],
#                           exchange: ENV["EVENT_EMITTER_EXCHANGE"],
#                           exchange_type: :topic,
#                           durable: true,
#                           ack: true,
#                         })
#     end

#     def update_emitted_at_timestamp(object)
#       object.update(emitted_at: Time.now)
#     end
#   end
# end
