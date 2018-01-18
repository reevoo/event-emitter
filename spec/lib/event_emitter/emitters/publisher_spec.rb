require "spec_helper"

require "fast_response/models/response"
require "fast_response/event_emitters/publisher"

describe EventEmitters::Publisher do
  let(:response) do
    FastResponse::Response.new(
      user_id: SecureRandom.uuid,
      content_id: SecureRandom.uuid,
      content_type: "product_review",
      type: "public",
      text: "something else",
      responder_custom_title: "Customer Services",
      responder_first_name: "Joe",
      responder_surname: "Doe",
      responder_job_title: "Head of Support",
    )
  end

  let(:messaging_backend) do
    double(
      :messaging_backend,
      emit_event: double(:emit_event),
    )
  end

  describe "#emit_event" do
    let(:raise_errors) { true }

    subject do
      described_class.new(raise_errors: raise_errors)
    end

    before do
      Timecop.freeze(Time.now)

      allow(EventEmitter).to receive(:new).and_return(messaging_backend)
      allow(SecureRandom).to receive(:uuid).and_return("1861e290-c92e-11e7-a1b1-000a27020050")
    end

    after do
      Timecop.return
    end

    context "missing params" do
      it "fails when entity_name is absent" do
        expect do
          subject.emit_event(operation: "create", object: double, backtrace: "spec")
        end.to raise_error("No entity")
      end

      it "fails when object is absent" do
        expect do
          subject.emit_event(entity_name: :response, operation: "create", backtrace: "spec")
        end.to raise_error("No object")
      end

      it "fails when operation is absent" do
        expect do
          subject.emit_event(entity_name: :response, object: double, backtrace: "spec")
        end.to raise_error("No operation")
      end
    end

    context "when errors happen" do
      let(:raise_errors) { false }

      context "raise_errors option is false" do
        it "does not raise error" do
          expect do
            subject.emit_event(entity_name: "INVALID ENTITY", object: double, operation: "create", backtrace: "spec")
          end.not_to raise_error
        end

        it "always calls ErrorHandler.handle_exception" do
          expect(FastResponse::EventEmitters::ErrorHandler).to receive(:handle_exception).with(
            entity_name: "INVALID ENTITY",
            object: "{}",
            operation: "create",
            backtrace: "spec",
            raise_errors: false,
          )
          subject.emit_event(entity_name: "INVALID ENTITY", object: {}, operation: "create", backtrace: "spec")
        end
      end

      context "raise_errors option is true" do
        let(:raise_errors) { true }

        it "raises error" do
          expect do
            subject.emit_event(entity_name: "INVALID ENTITY", object: double, operation: "create", backtrace: "spec")
          end.to raise_error("Unsupported entity: INVALID ENTITY")
        end

        it "always calls ErrorHandler.handle_exception if model absent" do
          expect(FastResponse::EventEmitters::ErrorHandler).to receive(:handle_exception).with(
            entity_name: "INVALID ENTITY",
            object: "{}",
            operation: "create",
            backtrace: "spec",
            raise_errors: true,
          )

          subject.emit_event(entity_name: "INVALID ENTITY", object: {}, operation: "create", backtrace: "spec")
        end
      end
    end

    context "response event" do
      let(:params) do
        {
          entity_name: :response,
          object: response,
          operation: :create,
          backtrace: "spec",
        }
      end

      let(:expected_message) do
        {
          message: FastResponse::EventEmitters::MessageBuilder.build(params).to_json,
          options: {
            to_queue: "response_events_queue", routing_key: "response_events_queue",
          },
        }
      end

      before do
        response.save
      end

      context "message json format" do
        it "emits a purchaser order event with the correct json format" do
          expect(messaging_backend).to receive(:publish).with(expected_message)

          subject.emit_event(params)
        end
      end

      context "updating emitted_at of a record after emitting an event" do
        before do
          allow(messaging_backend).to receive(:publish).and_return(true)
        end

        it "updates emitted_at time after emitting the event" do
          expect { subject.emit_event(params) }.to change(response, :emitted_at)
        end
      end
    end
  end
end
