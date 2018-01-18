describe EventEmitters::MessageBuilder do
  describe "#build" do
    let(:response) do
      Response.create(
        user_id: SecureRandom.uuid,
        content_id: SecureRandom.uuid,
        content_type: "product_review",
        type: "public",
        text: "something else",
        status: "deleted",
        responder_custom_title: "Customer Services",
        responder_first_name: "Joe",
        responder_surname: "Doe",
        responder_job_title: "Head of Support",
      )
    end

    let(:operation) { "create" }
    let(:backtrace) { "called from spec" }

    let(:params) do
      {
        entity_name: :response,
        object: response,
        operation: operation,
        backtrace: backtrace,
      }
    end

    before do
      Timecop.freeze

      allow(SecureRandom).to receive(:uuid).and_return("1861e290-c92e-11e7-a1b1-000a27020050")
    end

    after do
      Timecop.return
    end

    context "response" do
      it "creates a response with proper content" do
        expect(described_class.build(params)).to eq(
          meta: {
            message_uuid: "1861e290-c92e-11e7-a1b1-000a27020050",
            message_created_at: Time.now.utc.to_s,
            message_operation: operation,
            message_backtrace: backtrace,
          },
          message: {
            response: {
              id: response.id,
              user_id: response.user_id,
              content_id: response.content_id,
              subject_line: response.subject_line,
              text: "something else",
              created_at: response.created_at,
            },
          },
        )
      end
    end

    context "proper message builder" do
      let(:builder) { double(build: double) }

      it "uses response builder for response entity" do
        expect(EventEmitters::MessageBuilders::Response).to receive(:new).and_return(builder)

        described_class.build(
          entity_name: :response,
          object: double,
          operation: double,
          backtrace: double,
        )
      end
    end
  end
end
