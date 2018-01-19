require "timecop"

RSpec.describe Emitters::MessageBuilder do
  describe "#build" do
    let(:operation) { "create" }
    let(:backtrace) { "called from spec" }
    let(:message) do
      {
        response: {
          id: "id",
          user_id: "user_id",
          content_id: "blabla",
          subject_line: "subject",
          text: "something else",
          created_at: "created_at",
        },
      }
    end

    before do
      Timecop.freeze

      allow(SecureRandom).to receive(:uuid).and_return("1861e290-c92e-11e7-a1b1-000a27020050")
    end

    after do
      Timecop.return
    end

    it "takes an operation, backtrace and message and returns an hash" do
      expect(described_class.build(operation: operation, backtrace: backtrace, message: message)).to eq(
       meta: {
         message_uuid: "1861e290-c92e-11e7-a1b1-000a27020050",
         message_created_at: Time.now.utc.to_s,
         message_operation: operation,
         message_backtrace: backtrace,
       },
       message: {
         response: {
           id: "id",
           user_id: "user_id",
           content_id: "blabla",
           subject_line: "subject",
           text: "something else",
           created_at: "created_at",
         },
       },
              )
    end
  end
end
