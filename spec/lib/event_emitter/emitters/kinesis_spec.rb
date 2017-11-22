RSpec.describe Emitters::Kinesis do
  describe "#publish" do
    let(:publisher) { double(:publisher, put_records: true, put_record: true) }
    let(:stream) { double }
    let(:message) { double }
    let(:options) { {} }

    subject do
      described_class.publish(message: message, options: options)
    end

    before do
      allow(KinesisPublisher).to receive(:new).and_return(publisher)
      allow(KinesisStream).to receive(:new).and_return(stream)
    end

    it "accepts 2 arguments - message and options" do
      expect(subject).to eq(true)
    end

    context "with one message as message" do
      let(:message) { double(:message) }

      it "calls put_record" do
        expect(publisher).to receive(:put_record).and_return(true)

        subject
      end
    end

    context "with many messages as message" do
      let(:message) { [double(:message), double(:message)] }

      it "calls put_records" do
        expect(publisher).to receive(:put_records).and_return(true)

        subject
      end
    end
  end
end
