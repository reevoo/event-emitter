RSpec.describe EventEmitter do
  let(:emitter_options) { {} }
  let(:emitter) { described_class.new(backend: backend, options: emitter_options) }

  describe "#initialize" do
    context "kinesis" do
      let(:backend) { :kinesis }

      it "accepts kinesis as backend" do
        expect(emitter.backend).to eq(KinesisEmitter)
      end
    end
  end

  describe "#publish" do
    context "kinesis" do
      let(:backend) { :kinesis }
      let(:message) { "message1" }
      let(:publish_options) { { stream_name: "my_stream" } }

      it "calls publish on the backend class" do
        expect(KinesisEmitter).to receive(:publish).with(message: message, options: publish_options)

        emitter.publish(message: message, options: publish_options)
      end

      context "with EVENT_EMISSION_ENABLED set to false" do
        it "does not call publish on the backend class" do
          ClimateControl.modify EVENT_EMISSION_ENABLED: "false" do
            expect(KinesisEmitter).not_to receive(:publish)

            emitter.publish(message: message, options: publish_options)
          end
        end
      end
    end

    context "rabbitmq" do
      let(:backend) { :rabbitmq }

      let(:emitter_options) do
        {
          amqp: "amqp://porta:5766",
          vhost: "/",
          exchange: "my-exchange",
          exchange_type: :topic,
          durable: true,
          ack: true,
        }
      end

      let(:message) { "message1" }

      let(:publish_options) { { to_queue: "my_queue", routing_key: "routing_key" } }

      let(:sneakers_publisher) do
        double(
          :sneakers_publisher,
          publish: "OK",
        )
      end


      it "calls publish on the backend class" do
        expect(Sneakers::Publisher).to receive(:new).with(emitter_options).once.and_return(sneakers_publisher)
        expect_any_instance_of(RabbitMQEmitter).to receive(:publish).with(message: message, options: publish_options)

        emitter.publish(message: message, options: publish_options)
      end

      context "with EVENT_EMISSION_ENABLED set to false" do
        it "does not call publish on the backend class" do
          ClimateControl.modify EVENT_EMISSION_ENABLED: "false" do
            expect(Sneakers::Publisher).to receive(:new).with(emitter_options).once.and_return(sneakers_publisher)
            expect_any_instance_of(RabbitMQEmitter).not_to receive(:publish)

            emitter.publish(message: message, options: publish_options)
          end
        end
      end
    end
  end
end
