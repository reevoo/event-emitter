RSpec.describe EventEmitter::KinesisStream do
  let(:stream_description) { { stream_status: "ACTIVE", shards: double(size: 1) } }
  let(:client) { double(:client, describe_stream: { stream_description: stream_description }) }
  let(:options) do
    { create_stream: true, wait_for_stream_creation: false, stream_name: "my_stream", stream_shard_count: 1 }
  end
  let(:stream) { described_class.new(client: client, options: options) }

  before do
    allow(Aws::Kinesis::Client).to receive(:new).and_return(client)
  end

  describe "#initialize" do
    context "creating a stream" do
      context "while it's being deleted" do
        let(:stream_description) { { stream_status: "DELETING", shards: double(size: 1) } }

        it "fails when the stream is being deleted" do
          expect { stream }.to raise_error(RuntimeError)
        end
      end

      context "while it already exists" do
        let(:stream_description) { { stream_status: "ACTIVE", shards: double(size: 5) } }

        it "with different number of shards" do
          expect { stream }.to raise_error(RuntimeError)
        end
      end

      context "for the first time" do
        before do
          allow(client).to receive(:describe_stream)
            .and_raise(Aws::Kinesis::Errors::ResourceNotFoundException.new("blah", "message"))
        end

        it "creates the stream" do
          expect(client).to receive(:create_stream).with(stream_name: "my_stream", shard_count: 1)

          stream
        end
      end
    end
  end

  describe "#name" do
    it "is a name of a stream" do
      expect(stream.name).to eq(options[:stream_name])
    end
  end

  describe "#delete" do
    it "deletes a stream with a given name" do
      expect(client).to receive(:delete_stream).with(stream_name: options[:stream_name]).and_return(true)

      stream.delete
    end
  end
end
