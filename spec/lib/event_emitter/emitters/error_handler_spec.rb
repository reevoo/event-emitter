require "spec_helper"

RSpec.describe Emitters::ErrorHandler do
  describe "#handle_exception" do
    it "does not raise error if 'raise_error' option is false" do
      expect do
        described_class.handle_exception(raise_errors: false) do
          fail "Error"
        end
      end.not_to raise_error
    end

    it "does raise error if 'raise_error' option is true" do
      expect do
        described_class.handle_exception(raise_errors: true) do
          fail "Error"
        end
      end.to raise_error("Error")
    end
  end
end
