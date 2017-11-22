# EventEmitter

## Include the gem in your project
&nbsp;
gem 'reevoo_event_emitter'

## Enable/Disable Event emitting
&nbsp;
Once you include this gem in your project, make sure to set an environment variable:

```
EVENT_EMISSION_ENABLED = true
```

By default event emission is disabled so calling the publish method will have no effect. Once you set the environment variable to true the events will be published via your chosen backend.

## Running the Specs
&nbsp;
```
bundle exec rake
```

## RabbitMQ backend
&nbsp;
You can create an instance of our EventEmitter class configured to publish to RabbitMQ queues.
To do that, make sure you specify the backend as :rabbitmq, as in the example below:

```ruby
event_emitter_instance = EventEmitter.new(backend: :rabbitmq, options: {
   amqp: "amqp://guest:guest@localhost:5672",
   vhost: "/",
   exchange: "my-exchange",
   exchange_type: :topic,
   durable: true,
   ack:true,
})
```

**Note**: The RabbitMQ backend is using underneath a Sneakers::Publisher instance, so in "options" you can specify all the same properties accepted by the Sneakers::Publisher initializer method.


##### Publishing messages to a queue
&nbsp;
Assuming you have created an "event_emitter_instance" as in the example above, you can publish to a queue as in the example below:

```ruby
event_emitter_instance.publish(
  "I like sweet chilly chicken",
  to_queue: "some_queue",
  routing_key: "some_routing_key",
)
```

## Amazon Kinesis backend
&nbsp;
To make use of Kinesis streams set the following ENV variables indicating how to access the AWS account where the kinesis streams live:
```
ENV['AWS_ACCESS_KEY_ID']
ENV['AWS_SECRET_ACCESS_KEY']
ENV['AWS_REGION']
```
##### Publishing messages to a stream that already exists
&nbsp;
```ruby
EventEmitter.new(backend: :kinesis).publish(
  message: "Spicy chicken wings",
  options: {
    stream_name: 'kfc_stream',
  }
)
```
##### Publishing messages and creating the stream at the same time if it doesn't exist already
&nbsp;
```ruby
EventEmitter.new(backend: :kinesis).publish(
  message: "I like sweet chilly chicken",
  options: {
    stream_name: 'new_stream_for_my_chickens',
    create_stream: true,
    stream_shard_count: 8,
    wait_for_stream_creation: true,
  }
)
```
*Make sure you only specify the create stream once, and in subsequent calls to publish don't provide the "create_stream" parameter anymore, as otherwise each time you push a message there will be an extra check and attempt to create the stream, which will result in worse performance.*

Alternatively, you can create the stream behorehand by calling the following in our Kinesis::Stream class:

```ruby
Kinesis::Stream.new(
  client: Aws::Kinesis::Client.new,
  options: {
    create_stream: true,
    stream_shard_count: 1,
    stream_name: 'my_new_test_stream_name',
  }
)
```

You can also delete a stream using the library, as below:

```ruby
Kinesis::Stream.new(client: Aws::Kinesis::Client.new, stream_name: 'to_be_deleted').delete
```

##### Publishing multiple messages in batch
&nbsp;
To do batch publishing, pass all the messages in a comma separated array to the "message" parameter. As in the below example:
```ruby
EventEmitter.new(backend: :kinesis).publish(
  message: ["Bulbasaur", "Pikachu", "Charmander"],
  options: {
    stream_name: 'pokemons_stream',
  }
)
```

##### Available options for the publish method

These options may/must be passed in options hash:

- `stream_name` - *required* - name of the stream where you want to publish messages or a new stream name
- `create_stream` - *optional* - attempt to create a new stream
- `wait_for_stream_creation` - *optional* - wait for a created stream status to become ACTIVE
- `stream_shard_count` - *optional* - number of shards you want for a new stream
- `partition_key` - *optional* - partition key for your message/messages to go to specific shard, defaults to a random number
