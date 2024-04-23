## ✨ anthropic-rb ✨

Ruby bindings for the Anthropic API. This library is unofficial and is not affiliated with Anthropic PBC.

The goal of this project is feature parity with Anthropic's Python SDK until an official Ruby SDK is available.

You can find examples of usage in the [anthropic-rb-cookbook](https://github.com/dickdavis/anthropic-rb-cookbook/).

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

You can send a request to the Messages API.

```ruby
Anthropic.messages.create(model: 'claude-2.1', max_tokens: 200, messages: [{role: 'user', content: 'Yo what up?'}])

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
Anthropic.messages.create(model: 'claude-2.1', max_tokens: 200, messages: [{role: 'user', content: 'Yo what up?'}], stream: true) do |event|
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

You can also experiment with the new tools beta by passing the `beta` name when calling the API. This will ensure each request includes the correct beta header and validate properly.

```ruby
tools = [
  {
    name: 'get_weather',
    description: 'Get the current weather in a given location',
    input_schema: {
      type: 'object',
      properties: {
        location: { type: 'string' }
      },
      required: ['location']
    }
  }
]

Anthropic.messages(beta: 'tools-2024-04-04').create(
  model: 'claude-3-opus-20240229',
  max_tokens: 200,
  tools:,
  messages: [{role: 'user', content: 'What is the weather like in Nashville?'}]
)
```

Streaming is currently not supported by the tools beta. You can find out more information about tools in the [documentation](https://docs.anthropic.com/claude/docs/tool-use).

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

To run a sanity check, run `ruby sanity_check.rb`.

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dickdavis/anthropic-rb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

