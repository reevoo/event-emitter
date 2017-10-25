RSpec.describe EventEmitter::Kinesis::Publisher do
  let(:client) { double(:client) }
  let(:options) { { stream_name: "my_stream", partition_key: "some_key" } }
  let(:stream) { double(:stream, name: "my_stream") }
  let(:payload) { "blah" }
  let(:publisher) { described_class.new(payload: payload, options: options, client: client, stream: stream) }


  describe "#put_record" do
    before do
      allow(client).to receive(:put_record).with(
        data: payload,
        stream_name: stream.name,
        partition_key: "some_key",
      ).and_return(true)
    end

    it "calls put_record on aws client" do
      expect(publisher.put_record).to eq(true)
    end
  end

  describe "#put_records" do
    let(:payload) { %w[blah1 blah2] }

    before do
      allow(client).to receive(:put_records).with(
        records: [
          {
            data: "blah1",
            partition_key: "some_key",
          },
          {
            data: "blah2",
            partition_key: "some_key",
          },
        ],
        stream_name: stream.name,
      ).and_return(true)
    end

    it "calls put_records on aws client" do
      expect(publisher.put_records).to eq(true)
    end
  end
end
