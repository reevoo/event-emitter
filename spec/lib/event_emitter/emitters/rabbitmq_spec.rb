RSpec.describe Emitters::RabbitMQ do
  describe "publish" do
    # let(:message) { double(:message) }
    let(:message) { { message: "message" } }
    let(:emitter_options) { { entity_name: "entity_name" } }
    let(:config) { double(:config, queue_name_prefix: nil) }
    let(:expected_options) { { to_queue: "entity_name_events_queue", routing_key: "entity_name_events_queue" } }

    context "hello" do
      let(:sneakers_publisher) { double(:sneakers, publish: true) }

      it "calls Sneakers::Publisher with passed options" do
        expect(Sneakers::Publisher).to receive(:new).with(expected_options).once.and_return(sneakers_publisher)

        described_class.publish(message: message, options: emitter_options, config: config)
      end
    end

    context "when queue_name is initialize" do
      context "with a queue_name_prefix" do
        let(:message) { double(:message_1) }
        let(:config) { double(:config_1, queue_name_prefix: "queue_name") }
        let(:expected_options) do
          { to_queue: "queue_name_entity_name_events_queue", routing_key: "queue_name_entity_name_events_queue" }
        end

        it "returns a queue with queue name prefix" do
          expect(Sneakers::Publisher).to receive(:new).with(expected_options).and_return(double(publish: true))

          described_class.publish(message: message, options: emitter_options, config: config)
        end
      end

      context "without a queue_name_prefix" do
        let(:message) { double(:message_2) }
        let(:config) { double(:config_2, queue_name_prefix: nil) }
        let(:expected_options) { { to_queue: "entity_name_events_queue", routing_key: "entity_name_events_queue" } }

        it "returns a queue without queue name prefix" do
          expect(Sneakers::Publisher).to receive(:new).with(expected_options).and_return(double(publish: true))

          described_class.publish(message: message, options: emitter_options, config: config)
        end
      end
    end
  end
  # let(:emitter_options) do
  #   {
  #     amqp: "amqp://porta:5766",
  #     vhost: "/",
  #     exchange: "my-exchange",
  #     exchange_type: :topic,
  #     durable: true,
  #     ack: true,
  #   }
  # end
  #
  # let(:sneakers_publisher) do
  #   double(
  #     :sneakers_publisher,
  #     publish: "OK",
  #   )
  # end
  #
  # let(:emitter_options_2) do
  #   {
  #     amqp: "amqp://localhost:5766",
  #     vhost: "/",
  #     exchange: "another-exchange",
  #     exchange_type: :topic,
  #     durable: true,
  #     ack: true,
  #   }
  # end
  #
  # let(:sneakers_publisher_2) do
  #   double(
  #     :sneakers_publisher,
  #     publish: "OK",
  #   )
  # end
  #
  # let(:publish_options) { { to_queue: "my_queue", routing_key: "routing_key" } }
  # let(:subject) { described_class.new(options: emitter_options) }
  # let(:config) { {backend:, :amqp, :vhost, :exchange, :exchange_type, :durable, :ack, :raise_errors, :logger} }
  #
  #
  # describe "#initialize" do
  #   it "creates an underline Sneakers::Publisher instance with the provided options" do
  #     expect(Sneakers::Publisher).to receive(:new).with(emitter_options).once.and_return(sneakers_publisher)
  #
  #     subject
  #   end
  # end
  #
  # describe "#publish" do
  #   it "re-uses the same Sneakers::Publisher instance as long as we are using the same emitter instance" do
  #     expect(Sneakers::Publisher).to receive(:new).with(emitter_options).once.and_return(sneakers_publisher)
  #     expect(sneakers_publisher).to receive(:publish).with("message1", publish_options).once
  #     expect(sneakers_publisher).to receive(:publish).with("message2", publish_options).once
  #
  #     subject.publish(message: "message1", options: publish_options, config: config)
  #     subject.publish(message: "message2", options: publish_options, config: config)
  #   end
  #
  #   it "uses different Sneakers::Publisher instances if we are using different emitter instances" do
  #     expect(Sneakers::Publisher).to receive(:new).with(emitter_options).once.and_return(sneakers_publisher)
  #     expect(Sneakers::Publisher).to receive(:new).with(emitter_options_2).once.and_return(sneakers_publisher_2)
  #     expect(sneakers_publisher).to receive(:publish).with("message1", publish_options).once
  #     expect(sneakers_publisher_2).to receive(:publish).with("message2", publish_options).once
  #
  #     emitter1 = described_class.new(options: emitter_options)
  #     emitter2 = described_class.new(options: emitter_options_2)
  #     emitter1.publish(message: "message1", options: publish_options, config: config)
  #     emitter2.publish(message: "message2", options: publish_options, config: config)
  #   end
  # end
end
