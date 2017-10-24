RSpec.describe EventEmitter::Kinesis do
  describe "#publish" do
    let(:publisher) { double(:publisher, put_records: true, put_record: true) }
    let(:stream) { double }
    let(:payload) { double }
    let(:options) { {} }

    subject do
      described_class.publish(payload, options)
    end

    before do
      allow(EventEmitter::Kinesis::Publisher).to receive(:new).and_return(publisher)
      allow(EventEmitter::Kinesis::Stream).to receive(:new).and_return(stream)
    end

    it 'accepts 2 arguments - payload and options' do
      expect(subject).to eq(true)
    end

    context 'with one message as payload' do
      let(:payload) { double(:payload) }

      it 'calls put_record' do
        expect(publisher).to receive(:put_record).and_return(true)

        subject
      end
    end

    context 'with many messages as payload' do
      let(:payload) { [double(:payload), double(:payload)] }

      it 'calls put_records' do
        expect(publisher).to receive(:put_records).and_return(true)

        subject
      end
    end
  end
end