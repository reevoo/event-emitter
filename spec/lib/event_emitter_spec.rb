RSpec.describe EventEmitter do
  let(:emitter) { described_class.new(backend) }

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
      let(:options) { { stream_name: "my_stream" } }

      it "calls publish on the backend class" do
        expect(KinesisEmitter).to receive(:publish).with(message: message, options: options)

        emitter.publish(message: message, options: options)
      end

      context "with EVENT_EMISSION_ENABLED set to false" do
        it "does not call publish on the backend class" do
          ClimateControl.modify EVENT_EMISSION_ENABLED: "false" do
            expect(KinesisEmitter).not_to receive(:publish)

            emitter.publish(message: message, options: options)
          end
        end
      end
    end
  end
end
