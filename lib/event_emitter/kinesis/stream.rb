module Kinesis
  class Stream

    attr_reader :client, :options

    def initialize(client:, options:)
      @client = client
      @options = options
      @options[:wait_for_stream_creation] = true if @options[:wait_for_stream_creation].nil?

      create_stream_if_not_exists if @options[:create_stream]
    end

    def name
      options[:stream_name]
    end

    def delete
      client.delete_stream(stream_name: name)
    rescue => e
      puts e.to_s
    end

    private

    def shard_count
      options[:stream_shard_count]
    end

    def create_stream_if_not_exists
      desc = stream_description

      check_stream_status(desc)
      check_shard_count(desc)

      puts "Stream #{name} already exists with #{desc[:shards].size} shards"
    rescue Aws::Kinesis::Errors::ResourceNotFoundException
      puts "Creating stream #{name} with #{shard_count || 1} shards"
      create_stream
    end

    def check_stream_status(stream_description)
      if stream_description[:stream_status] == "DELETING"
        fail "Stream #{name} is being deleted. Please re-run the script."
      elsif stream_description[:stream_status] != "ACTIVE"
        wait_for_stream_to_become_active
      end
    end

    def check_shard_count(stream_description)
      if shard_count && stream_description[:shards].size != shard_count
        fail "Stream #{name} has #{stream_description[:shards].size} shards, but requested #{shard_count} shards"
      end
    end

    def create_stream
      client.create_stream(stream_name: name, shard_count: shard_count || 1)
      wait_for_stream_to_become_active if options[:wait_for_stream_creation]
    end

    def wait_for_stream_to_become_active
      sleep_time_seconds = 3
      status = stream_description[:stream_status]

      while status && status != "ACTIVE"
        puts "#{name} has status: #{status}, sleeping for #{sleep_time_seconds} seconds"
        sleep(sleep_time_seconds)
        status = stream_description[:stream_status]
      end
    end

    def stream_description
      r = client.describe_stream(stream_name: name)
      r[:stream_description]
    end
  end
end
