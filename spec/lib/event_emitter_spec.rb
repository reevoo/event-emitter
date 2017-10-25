RSpec.describe EventEmitter do
  let(:emitter) { described_class.new(backend) }

  describe "#initialize" do
    context "kinesis" do
      let(:backend) { :kinesis }

      it 'accepts kinesis as backend' do
        expect(emitter.backend).to eq(KinesisEmitter)
      end
    end
  end

  describe "#publish" do
    context "kinesis" do
      let(:backend) { :kinesis }
      let(:payload) { "message1" }
      let(:options) { { stream_name: "my_stream" } }

      it 'calls publish on the backend class' do
        expect(KinesisEmitter).to receive(:publish).with(payload: payload, options: options)

        emitter.publish(payload: payload, options: options)
      end
    end
  end
end