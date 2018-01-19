require "spec_helper"

RSpec.describe Emitters::Config do
  let(:config) { described_class.new }

  describe "#to_hash" do
    let(:backend) { :rabbitmq }
    let(:amqp) { "some_url" }
    let(:vhost) { "vhost_here" }
    let(:exchange) { "very_nice_exchange" }
    let(:exchange_type) { "good_type" }
    let(:durable) { "always" }
    let(:ack) { "not_really" }
    let(:emission_enabled) { "of_course" }
    let(:queue_name_prefix) { "la_baguette" }

    before do
      config.backend = backend
      config.amqp = amqp
      config.vhost = vhost
      config.exchange = exchange
      config.exchange_type = exchange_type
      config.durable = durable
      config.ack = ack
      config.emission_enabled = emission_enabled
      config.queue_name_prefix = queue_name_prefix
    end

    it "converts config object into hash" do
      expect(config.to_hash).to eq(
                  backend: backend,
                  amqp: amqp,
                  vhost: vhost,
                  exchange: exchange,
                  exchange_type: exchange_type,
                  durable: durable,
                  ack: ack,
                  emission_enabled: emission_enabled,
                  queue_name_prefix: queue_name_prefix,
      )
    end
  end

  describe "#emission_enabled?" do
    context "boolean true" do
      before do
        config.emission_enabled = true
      end

      it "is true if config has boolean true value" do
        expect(config.emission_enabled?).to eq(true)
      end
    end

    context "boolean false" do
      before do
        config.emission_enabled = false
      end

      it "is false if config has boolean false value" do
        expect(config.emission_enabled?).to eq(false)
      end
    end

    context "any other value" do
      before do
        config.emission_enabled = "true"
      end

      it "is false if config does not have boolean true" do
        expect(config.emission_enabled?).to eq(false)
      end
    end
  end
end
