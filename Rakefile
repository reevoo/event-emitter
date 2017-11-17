begin
  require "bundler/gem_tasks"
  require "rspec/core/rake_task"
  require "reevoocop/rake_task"
  require "event_emitter/version"

  task :test_env do
    begin
      require "dotenv"
      Dotenv.load(".env.test")
    rescue LoadError
      puts "WARNING: Failed to load .env.test!"
    end
  end

  RSpec::Core::RakeTask.new(rspec: "test_env") do |_task|
    puts "\n #{"*" * 10} Testing RSpec #{"*" * 10}"
  end

  ReevooCop::RakeTask.new(:reevoocop)

  task default: %w(rspec reevoocop)
rescue LoadError => e
  puts "Dependencies not loaded: #{e.inspect}"
end
