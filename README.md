# EventEmitter
Contains logic for event emitting

# Usage

## Amazon Kinesis

Set ENV variables:

- ENV['AWS_ACCESS_KEY_ID']

- ENV['AWS_SECRET_ACCESS_KEY']

- ENV['AWS_REGION']

### Publishing messages

To publish **one** message:

```
EventEmitter::Kinesis.publish(message, stream_name: 'stream_name')
```

To publish **many** messages:

```
EventEmitter::Kinesis.publish([message1, message2], stream_name: 'stream_name')
```
