module EventEmitter
  module Kinesis
    class Stream

      attr_reader :client, :options

      def initialize(client:, options:)
        @client = client
        @options = options
        @options[:wait_for_stream_creation] = true if @options[:wait_for_stream_creation].nil?

        create_stream_if_not_exists
      end

      def name
        options[:stream_name]
      end

      def delete
        begin
          client.delete_stream(stream_name: name)
        rescue => e
          puts e.to_s
        end
      end

      private

      def shard_count
        options[:stream_shard_count]
      end

      def create_stream_if_not_exists
        begin
          desc = get_stream_description

          if desc[:stream_status] == 'DELETING'
            fail "Stream #{name} is being deleted. Please re-run the script."
          elsif desc[:stream_status] != 'ACTIVE'
            wait_for_stream_to_become_active
          end

          if shard_count && desc[:shards].size != shard_count
            fail "Stream #{name} has #{desc[:shards].size} shards, while requested number of shards is #{shard_count}"
          end

          puts "Stream #{name} already exists with #{desc[:shards].size} shards"
        rescue Aws::Kinesis::Errors::ResourceNotFoundException
          puts "Creating stream #{name} with #{shard_count || 1} shards"
          @client.create_stream(:stream_name => name, :shard_count => shard_count || 1)
          wait_for_stream_to_become_active if options[:wait_for_stream_creation]
        end
      end

      def wait_for_stream_to_become_active
        sleep_time_seconds = 3
        status = get_stream_description[:stream_status]
        while status && status != 'ACTIVE' do
          puts "#{name} has status: #{status}, sleeping for #{sleep_time_seconds} seconds"
          sleep(sleep_time_seconds)
          status = get_stream_description[:stream_status]
        end
      end

      def get_stream_description
        r = client.describe_stream(stream_name: name)
        r[:stream_description]
      end
    end
  end
end