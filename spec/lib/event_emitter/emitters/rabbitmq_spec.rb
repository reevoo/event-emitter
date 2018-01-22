RSpec.describe Emitters::RabbitMQ do
  describe "publish" do
    let(:message) { double(:message) }
    let(:emitter_options) { { entity_name: "entity_name" } }
    let(:config) { double(:config, queue_name_prefix: nil) }
    let(:expected_options) { { to_queue: "entity_name_events_queue", routing_key: "entity_name_events_queue" } }
    let(:sneakers_publisher) { double(:sneakers, publish: true) }

    it "calls and memoizes Sneakers::Publisher" do
      expect(Sneakers::Publisher).to receive(:new).with(expected_options).once.and_return(sneakers_publisher)

      described_class.publish(message: message, options: emitter_options, config: config)
      described_class.publish(message: message, options: emitter_options, config: config)
    end

    context "queue_name" do
      context "without a queue_name_prefix" do
        it "returns a queue without queue name prefix" do
          expect(described_class.send(:queue_name, options: emitter_options, config: config)).to eq("entity_name_events_queue")
        end
      end

      context "with a queue_name_prefix" do
        let(:config) { double(:config_with_prefix, queue_name_prefix: "queue_name") }

        it "returns a queue with queue name prefix" do
          expect(described_class.send(:queue_name, options: emitter_options, config: config)).to eq("queue_name_entity_name_events_queue")
        end
      end
    end
  end
end
