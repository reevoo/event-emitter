RSpec.describe EventEmitter do
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
        config.emission_enabled = true
      end

      expect(described_class.config.backend).to eq(:my_favorite_backend)
      expect(described_class.config.amqp).to eq("some_amqp")
      expect(described_class.config.vhost).to eq("some_host")
      expect(described_class.config.exchange).to eq("some_exchange")
      expect(described_class.config.exchange_type).to eq(:topic)
      expect(described_class.config.durable).to eq(true)
      expect(described_class.config.ack).to eq(true)
      expect(described_class.config.emission_enabled).to eq(true)
    end
  end

  describe ".push" do
    context "with event emitting enabled" do
      context "choosing a backend class" do
        context "rabbitmq" do
          before do
            described_class.configure do |config|
              config.backend = :rabbitmq
              config.emission_enabled = true
            end
          end

          it "calls RabbitMQ backend" do
            expect(Emitters::RabbitMQ).to receive(:publish).and_return(true)

            described_class.push(entity_name: double, object: double, operation: double, backtrace: double)
          end
        end

        context "kinesis" do
          before do
            described_class.configure do |config|
              config.backend = :kinesis
              config.emission_enabled = true
            end
          end

          it "calls Kinesis backend" do
            expect(Emitters::Kinesis).to receive(:publish).and_return(true)

            described_class.push(entity_name: double, object: double, operation: double, backtrace: double)
          end
        end

        context "unknown backend" do
          before do
            described_class.configure do |config|
              config.backend = :unknown_backend
              config.emission_enabled = true
            end
          end

          it "fails" do
            expect do
              described_class.push(entity_name: double, object: double, operation: double, backtrace: double)
            end.to raise_error(Emitters::Error, "Unsupported backend: unknown_backend")
          end
        end
      end

      context "building a message in JSON format" do
        let(:operation) { double(:operation) }
        let(:backtrace) { double(:backtrace) }
        let(:message) { double(:message) }

        before do
          described_class.configure do |config|
            config.backend = :rabbitmq
            config.emission_enabled = true
          end
        end

        it "calls a message builder" do
          expect(Emitters::MessageBuilder).to receive(:build).with(
           operation: operation,
           backtrace: backtrace,
           message: message,
          ).and_return(double(to_json: "{}"))

          described_class.push(entity_name: double, object: message, operation: operation, backtrace: backtrace)
        end
      end
    end

    context "with event emitting disabled" do
      before do
        described_class.configure do |config|
          config.emission_enabled = false
        end
      end

      it "won't emit" do
        expect(
          described_class.push(entity_name: double, object: double, operation: double, backtrace: double),
        ).to eq(nil)
      end
    end
  end
end
