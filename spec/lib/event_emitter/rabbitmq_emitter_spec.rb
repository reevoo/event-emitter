RSpec.describe RabbitMQEmitter do
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

  let(:sneakers_publisher) do
    double(
      :sneakers_publisher,
      publish: "OK",
    )
  end

  let(:emitter_options_2) do
    {
      amqp: "amqp://localhost:5766",
      vhost: "/",
      exchange: "another-exchange",
      exchange_type: :topic,
      durable: true,
      ack: true,
    }
  end

  let(:sneakers_publisher_2) do
    double(
      :sneakers_publisher,
      publish: "OK",
    )
  end

  let(:publish_options) { { to_queue: "my_queue", routing_key: "routing_key" } }


  let(:subject) { described_class.new(options: emitter_options) }


  describe "#initialize" do
    it "creates an underline Sneakers::Publisher instance with the provided options" do
      expect(Sneakers::Publisher).to receive(:new).with(emitter_options).once.and_return(sneakers_publisher)

      subject
    end
  end

  describe "#publish" do
    it "re-uses the same Sneakers::Publisher instance as long as we are using the same emitter instance" do
      expect(Sneakers::Publisher).to receive(:new).with(emitter_options).once.and_return(sneakers_publisher)
      expect(sneakers_publisher).to receive(:publish).with("message1", publish_options).once
      expect(sneakers_publisher).to receive(:publish).with("message2", publish_options).once

      subject.publish(message: "message1", options: publish_options)
      subject.publish(message: "message2", options: publish_options)
    end

    it "uses different Sneakers::Publisher instances if we are using different emitter instances" do
      expect(Sneakers::Publisher).to receive(:new).with(emitter_options).once.and_return(sneakers_publisher)
      expect(Sneakers::Publisher).to receive(:new).with(emitter_options_2).once.and_return(sneakers_publisher_2)
      expect(sneakers_publisher).to receive(:publish).with("message1", publish_options).once
      expect(sneakers_publisher_2).to receive(:publish).with("message2", publish_options).once

      emitter1 = described_class.new(options: emitter_options)
      emitter2 = described_class.new(options: emitter_options_2)
      emitter1.publish(message: "message1", options: publish_options)
      emitter2.publish(message: "message2", options: publish_options)
    end
  end
end
