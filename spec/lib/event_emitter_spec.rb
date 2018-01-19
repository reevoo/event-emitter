RSpec.describe EventEmitter do
  let(:emitter_options) { {} }
  let(:emitter) { described_class.new(backend: backend, options: emitter_options) }

  describe "#initialize" do
    context "kinesis" do
      let(:backend) { :kinesis }

      it "accepts kinesis as backend" do
        expect(emitter.backend).to eq(Emitters::Kinesis)
      end
    end
  end
  #
  # describe "#publish" do
  #   context "kinesis" do
  #     let(:backend) { :kinesis }
  #     let(:message) { "message1" }
  #     let(:publish_options) { { stream_name: "my_stream" } }
  #
  #     it "calls publish on the backend class" do
  #       expect(Emitters::Kinesis).to receive(:publish).with(message: message, options: publish_options)
  #
  #       emitter.publish(message: message, options: publish_options)
  #     end
  #
  #     context "with EVENT_EMISSION_ENABLED set to false" do
  #       it "does not call publish on the backend class" do
  #         ClimateControl.modify EVENT_EMISSION_ENABLED: "false" do
  #           expect(Emitters::Kinesis).not_to receive(:publish)
  #
  #           emitter.publish(message: message, options: publish_options)
  #         end
  #       end
  #     end
  #   end
  #
  #   context "rabbitmq" do
  #     let(:backend) { :rabbitmq }
  #
  #     let(:emitter_options) do
  #       {
  #         amqp: "amqp://porta:5766",
  #         vhost: "/",
  #         exchange: "my-exchange",
  #         exchange_type: :topic,
  #         durable: true,
  #         ack: true,
  #       }
  #     end
  #
  #     let(:message) { "message1" }
  #
  #     let(:publish_options) { { to_queue: "my_queue", routing_key: "routing_key" } }
  #
  #     let(:sneakers_publisher) do
  #       double(
  #         :sneakers_publisher,
  #         publish: "OK",
  #       )
  #     end
  #
  #
  #     it "calls publish on the backend class" do
  #       expect(Sneakers::Publisher).to receive(:new).with(emitter_options).once.and_return(sneakers_publisher)
  #       expect_any_instance_of(Emitters::RabbitMQ).to receive(:publish).with(message: message, options: publish_options)
  #
  #       emitter.publish(message: message, options: publish_options)
  #     end
  #
  #     context "with EVENT_EMISSION_ENABLED set to false" do
  #       it "does not call publish on the backend class" do
  #         ClimateControl.modify EVENT_EMISSION_ENABLED: "false" do
  #           expect(Sneakers::Publisher).to receive(:new).with(emitter_options).once.and_return(sneakers_publisher)
  #           expect_any_instance_of(Emitters::RabbitMQ).not_to receive(:publish)
  #
  #           emitter.publish(message: message, options: publish_options)
  #         end
  #       end
  #     end
  #   end
  # end

  describe ".configure" do
    it "accepts a block with config options" do
      described_class.configure do |config|
        config.backend = :my_favorite_backend
        config.amqp = "some_amqp"
        config.vhost = "some_host"
        config.exchange = "some_exchange"
        config.exchange_type = :topic
        config.durable = true
        config.ack = true
        config.raise_errors = true
        config.logger = "some_logger"
      end

      expect(described_class.config.backend).to eq(:my_favorite_backend)
      expect(described_class.config.amqp).to eq("some_amqp")
      expect(described_class.config.vhost).to eq("some_host")
      expect(described_class.config.exchange).to eq("some_exchange")
      expect(described_class.config.exchange_type).to eq(:topic)
      expect(described_class.config.durable).to eq(true)
      expect(described_class.config.ack).to eq(true)
      expect(described_class.config.raise_errors).to eq(true)
      expect(described_class.config.logger).to eq("some_logger")
    end
  end

  describe ".push" do
    context "with event emitting enabled" do
      before do
        allow(ENV).to receive(:fetch).with("EVENT_EMISSION_ENABLED", "false").and_return("true")
      end

      context "choosing a backend class" do
        context "rabbitmq" do
          before do
            described_class.configure do |config|
              config.backend = :rabbitmq
            end
          end

          it "calls RabbitMQ backend" do
            expect(Emitters::RabbitMQ).to receive(:publish).and_return(true)

            described_class.push(double)
          end
        end

        context "kinesis" do
          before do
            described_class.configure do |config|
              config.backend = :kinesis
            end
          end

          it "calls Kinesis backend" do
            expect(Emitters::Kinesis).to receive(:publish).and_return(true)

            described_class.push(double)
          end
        end
      end
    end

    context "with event emitting disabled" do
      before do
        allow(ENV).to receive(:fetch).with("EVENT_EMISSION_ENABLED", "false").and_return("false")
      end

      it "won't emit" do
        expect(described_class.push(double)).to eq(nil)
      end
    end
  end
end
