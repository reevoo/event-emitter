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

```
EventEmitter::Kinesis.publish(message, create_stream: true, stream_name: 'my_new_stream', stream_shard_count: 8)
```

#### Creating a stream through console

You can do it as below:

```
aws_client = Aws::Kinesis::Client.new
EventEmitter::Kinesis::Stream.new(
  client: aws_client, 
  options: { create_stream: true, stream_name: 'my_new_test_stream', stream_shard_count: 1 }
)
```


#### Publishing messages to existing stream 

To publish **one** message:

```
EventEmitter::Kinesis.publish(message, stream_name: 'stream_name')
```

To publish **many** messages:

```
EventEmitter::Kinesis.publish([message1, message2], stream_name: 'stream_name')
```
