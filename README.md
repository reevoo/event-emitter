# EventEmitter
Contains logic for event emitting

# Usage

## Amazon Kinesis

Set ENV variables:

- ENV['AWS_ACCESS_KEY_ID']

- ENV['AWS_SECRET_ACCESS_KEY']

- ENV['AWS_REGION']

### Publishing messages

Publishing messages is not possible if a stream doesn't exist in AWS.
Creating a stream can be achieved in number of ways:
  - beforehand in AWS console or
  - while emitting a message or
  - creating it directly from console

#### Creating a stream while publishing a message

You need to pass `create_stream: true` in options. In addition to that
you can specify number of shards for the new stream via `stream_shard_count`.
*Make sure you create stream once and remove `create_stream` after successful creation. 
Otherwise each time you push a message there will be an attempt to create a stream which will result in worse performance.*

```ruby
EventEmitter::Kinesis.publish(message, create_stream: true, stream_name: 'my_new_stream', stream_shard_count: 8)
```

#### Creating a stream through console

You can do it as below:

```ruby
aws_client = Aws::Kinesis::Client.new
EventEmitter::Kinesis::Stream.new(
  client: aws_client, 
  options: { create_stream: true, stream_name: 'my_new_test_stream_name', stream_shard_count: 1 }
)
```


#### Publishing messages to existing stream 

AWS expects message to be a String or IO object. It means you can't pass Hash, you need to make it a String
for example by calling `to_json` on a message.

To publish **one** message:

```ruby
message = "Spicy chicken wings"

EventEmitter::Kinesis.publish(message, stream_name: 'kfc_stream')
```

```ruby
message = { uuid: "a0123-99zz", price: 2.99 }.to_json

EventEmitter::Kinesis.publish(message, stream_name: 'products')
```

To publish **many** messages:

```ruby
EventEmitter::Kinesis.publish([message1, message2, message3], stream_name: 'fat_stream')
```

### All available options

These options may/must be passed in options hash:

- `stream_name` - *required* - name of the stream where you want to publish messages or a new stream name
- `create_stream` - *optional* - attempt to create a new stream
- `wait_for_stream_creation` - *optional* - wait for a created stream status to become ACTIVE
- `stream_shard_count` - *optional* - number of shards you want for a new stream
- `partition_key` - *optional* - partition key for your message/messages to go to specific shard, defaults to "partition_key"
