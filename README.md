## ✨ anthropic-rb ✨

Ruby bindings for the Anthropic API. This library is unofficial and is not affiliated with Anthropic PBC.

The goal of this project is feature parity with Anthropic's Python SDK until an official Ruby SDK is available.

## Usage

anthropic-rb will default to the value of the `ANTHROPIC_API_KEY` environment variable. However, you may initialize the library with your API key. You must set your API key before using the library.

```ruby
require 'anthropic'

Anthropic.setup do |config|
  config.api_key = 'YOUR_API_KEY'
end
```

You can also specify an API version to use by setting the `ANTHROPIC_API_VERSION` environment variable or during initialization. This is optional; if not set, the library will default to `2023-06-01`.

```ruby
require 'anthropic'

Anthropic.setup do |config|
  config.api_version = '2023-06-01'
end
```

### Messages API

You can send a request to the Messages API. The Messages API is currently in beta; as such, you'll need to pass the `beta` flag when calling the API to ensure the correct header is included.

```ruby
Anthropic.messages(beta: true).create(model: 'claude-2.1', max_tokens: 200, messages: [{role: 'user', content: 'Yo what up?'}])

# Output =>
# {
#   id: "msg_013ePdwEkb4RMC1hCE61Hbm8",
#   type: "message",
#   role: "assistant",
#   content: [{type: "text", text: "Hello! Not much up with me, just chatting. How about you?"}],
#   model: "claude-2.1",
#   stop_reason: "end_turn",
#   stop_sequence: nil
# }
```

Alternatively, you can stream the response:

```ruby
Anthropic.messages(beta: true).create(model: 'claude-2.1', max_tokens: 200, messages: [{role: 'user', content: 'Yo what up?'}], stream: true) do |event|
  puts event
end

# Output =>
# { type: 'message_start', message: { id: 'msg_012pkeozZynwyNvSagwL7kMw', type: 'message', role: 'assistant', content: [], model: 'claude-2.1', stop_reason: nil, stop_sequence: nil } }
# { type: 'content_block_start', index: 0, content_block: { type: 'text', text: '' } }
# { type: 'content_block_delta', index: 0, delta: { type: 'text_delta', text: 'Hello' } }
# { type: 'content_block_delta', index: 0, delta: { type: 'text_delta', text: '.' } }
# { type: 'content_block_stop', index: 0 }
# { type: 'message_delta', delta: { stop_reason: 'end_turn', stop_sequence: nil } }
# { type: 'message_stop' }
```

### Completions API

To make a request to the Completions API:

```ruby
Anthropic.completions.create(
  model: 'claude-2',
  max_tokens_to_sample: 200,
  prompt: 'Human: Yo what up?\n\nAssistant:'
)

# Output =>
# {
#   completion: "Hello! Not much going on with me, just chatting. How about you?",
#   stop_reason: "stop_sequence",
#   model: "claude-2.1",
#   stop: "\n\nHuman:",
#   log_id: "2496914137c520ec2b4ae8315864bcf3a4c6ce9f2e3c96e13be4c004587313ca"
# }
```

Alternatively, you can stream the response:

```ruby
Anthropic.completions.create(model: 'claude-2', max_tokens_to_sample: 200, prompt: 'Human: Yo what up?\n\nAssistant:', stream: true) do |event|
  puts event
end

# Output =>
# { type: 'completion', id: 'compl_01G6cEfdZtLEEJVRzwUShiDY', completion: ' Hello', stop_reason: nil, model: 'claude-2.1', stop: nil, log_id: 'compl_01G6cEfdZtLEEJVRzwUShiDY' }
# { type: 'completion', id: 'compl_01G6cEfdZtLEEJVRzwUShiDY', completion: '!', stop_reason: nil, model: 'claude-2.1', stop: nil, log_id: 'compl_01G6cEfdZtLEEJVRzwUShiDY' }
# { type: 'completion', id: 'compl_01G6cEfdZtLEEJVRzwUShiDY', completion: ' Not', stop_reason: nil, model: 'claude-2.1', stop: nil, log_id: 'compl_01G6cEfdZtLEEJVRzwUShiDY' }
# { type: 'completion', id: 'compl_01G6cEfdZtLEEJVRzwUShiDY', completion: ' much', stop_reason: nil, model: 'claude-2.1', stop: nil, log_id: 'compl_01G6cEfdZtLEEJVRzwUShiDY' }
# { type: 'completion', id: 'compl_01G6cEfdZtLEEJVRzwUShiDY', completion: ',', stop_reason: nil, model: 'claude-2.1', stop: nil, log_id: 'compl_01G6cEfdZtLEEJVRzwUShiDY' }
# { type: 'completion', id: 'compl_01G6cEfdZtLEEJVRzwUShiDY', completion: ' just', stop_reason: nil, model: 'claude-2.1', stop: nil, log_id: 'compl_01G6cEfdZtLEEJVRzwUShiDY' }
# { type: 'completion', id: 'compl_01G6cEfdZtLEEJVRzwUShiDY', completion: ' chatting', stop_reason: nil, model: 'claude-2.1', stop: nil, log_id: 'compl_01G6cEfdZtLEEJVRzwUShiDY' }
# { type: 'completion', id: 'compl_01G6cEfdZtLEEJVRzwUShiDY', completion: ' with', stop_reason: nil, model: 'claude-2.1', stop: nil, log_id: 'compl_01G6cEfdZtLEEJVRzwUShiDY' }
# { type: 'completion', id: 'compl_01G6cEfdZtLEEJVRzwUShiDY', completion: ' people', stop_reason: nil, model: 'claude-2.1', stop: nil, log_id: 'compl_01G6cEfdZtLEEJVRzwUShiDY' }
# { type: 'completion', id: 'compl_01G6cEfdZtLEEJVRzwUShiDY', completion: '.', stop_reason: nil, model: 'claude-2.1', stop: nil, log_id: 'compl_01G6cEfdZtLEEJVRzwUShiDY' }
# { type: 'completion', id: 'compl_01G6cEfdZtLEEJVRzwUShiDY', completion: ' How', stop_reason: nil, model: 'claude-2.1', stop: nil, log_id: 'compl_01G6cEfdZtLEEJVRzwUShiDY' }
# { type: 'completion', id: 'compl_01G6cEfdZtLEEJVRzwUShiDY', completion: ' about', stop_reason: nil, model: 'claude-2.1', stop: nil, log_id: 'compl_01G6cEfdZtLEEJVRzwUShiDY' }
# { type: 'completion', id: 'compl_01G6cEfdZtLEEJVRzwUShiDY', completion: ' you', stop_reason: nil, model: 'claude-2.1', stop: nil, log_id: 'compl_01G6cEfdZtLEEJVRzwUShiDY' }
# { type: 'completion', id: 'compl_01G6cEfdZtLEEJVRzwUShiDY', completion: '?', stop_reason: nil, model: 'claude-2.1', stop: nil, log_id: 'compl_01G6cEfdZtLEEJVRzwUShiDY' }
# { type: 'completion', id: 'compl_01G6cEfdZtLEEJVRzwUShiDY', completion: '', stop_reason: 'stop_sequence', model: 'claude-2.1', stop: "\n\nHuman:", log_id: 'compl_01G6cEfdZtLEEJVRzwUShiDY' }
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'anthropic-rb'
```

And then execute:

```bash
bundle
```

Or install it yourself as:

```bash
gem install anthropic-rb
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dickdavis/anthropic-rb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

