## ✨ anthropic-rb ✨

**NOTICE**: Anthropic is rolling out an [official Ruby SDK](https://github.com/anthropics/anthropic-sdk-ruby). It's currently in beta and will be fully released after the `anthropic` gem is migrated over. Once the official release is out, this project will be archived. You are encouraged to start migrating over using that library as this project will no longer receive updates.

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
#<data Anthropic::Client::Response status="success", body={:id=>"msg_01UqHiw6oFLjMYiLV8hkXsrR", :type=>"message", :role=>"assistant", :model=>"claude-2.1", :content=>[{:type=>"text", :text=>"Hello! Not much up with me, just chatting with you. How's it going?"}], :stop_reason=>"end_turn", :stop_sequence=>nil, :usage=>{:input_tokens=>13, :output_tokens=>22}}>
```

Alternatively, you can stream the response:

```ruby
options = {
  model: 'claude-2.1',
  max_tokens: 200,
  messages: [{role: 'user', content: 'Yo what up?'}],
  stream: true
}

Anthropic.messages.create(**options) do |event|
  puts event
end

# Output =>
#<data Anthropic::Client::Response status="success", body={:type=>"message_start", :message=>{:id=>"msg_01EsYcQkBJrHrtgpY5ZcLzvf", :type=>"message", :role=>"assistant", :model=>"claude-2.1", :content=>[], :stop_reason=>nil, :stop_sequence=>nil, :usage=>{:input_tokens=>13, :output_tokens=>1}}}>
#<data Anthropic::Client::Response status="success", body={:type=>"content_block_start", :index=>0, :content_block=>{:type=>"text", :text=>""}}>
#<data Anthropic::Client::Response status="success", body={:type=>"content_block_delta", :index=>0, :delta=>{:type=>"text_delta", :text=>"Hello"}}>
#<data Anthropic::Client::Response status="success", body={:type=>"content_block_delta", :index=>0, :delta=>{:type=>"text_delta", :text=>"!"}}>
#<data Anthropic::Client::Response status="success", body={:type=>"content_block_delta", :index=>0, :delta=>{:type=>"text_delta", :text=>" Not"}}>
#<data Anthropic::Client::Response status="success", body={:type=>"content_block_delta", :index=>0, :delta=>{:type=>"text_delta", :text=>" much"}}>
#<data Anthropic::Client::Response status="success", body={:type=>"content_block_delta", :index=>0, :delta=>{:type=>"text_delta", :text=>" up"}}>
#<data Anthropic::Client::Response status="success", body={:type=>"content_block_delta", :index=>0, :delta=>{:type=>"text_delta", :text=>" with"}}>
#<data Anthropic::Client::Response status="success", body={:type=>"content_block_delta", :index=>0, :delta=>{:type=>"text_delta", :text=>" me"}}>
#<data Anthropic::Client::Response status="success", body={:type=>"content_block_delta", :index=>0, :delta=>{:type=>"text_delta", :text=>","}}>
#<data Anthropic::Client::Response status="success", body={:type=>"content_block_delta", :index=>0, :delta=>{:type=>"text_delta", :text=>" I"}}>
#<data Anthropic::Client::Response status="success", body={:type=>"content_block_delta", :index=>0, :delta=>{:type=>"text_delta", :text=>"'m"}}>
#<data Anthropic::Client::Response status="success", body={:type=>"content_block_delta", :index=>0, :delta=>{:type=>"text_delta", :text=>" an"}}>
#<data Anthropic::Client::Response status="success", body={:type=>"content_block_delta", :index=>0, :delta=>{:type=>"text_delta", :text=>" AI"}}>
#<data Anthropic::Client::Response status="success", body={:type=>"content_block_delta", :index=>0, :delta=>{:type=>"text_delta", :text=>" assistant"}}>
#<data Anthropic::Client::Response status="success", body={:type=>"content_block_delta", :index=>0, :delta=>{:type=>"text_delta", :text=>" create"}}>
#<data Anthropic::Client::Response status="success", body={:type=>"content_block_delta", :index=>0, :delta=>{:type=>"text_delta", :text=>"d by"}}>
#<data Anthropic::Client::Response status="success", body={:type=>"content_block_delta", :index=>0, :delta=>{:type=>"text_delta", :text=>" An"}}>
#<data Anthropic::Client::Response status="success", body={:type=>"content_block_delta", :index=>0, :delta=>{:type=>"text_delta", :text=>"throp"}}>
#<data Anthropic::Client::Response status="success", body={:type=>"content_block_delta", :index=>0, :delta=>{:type=>"text_delta", :text=>"ic"}}>
#<data Anthropic::Client::Response status="success", body={:type=>"content_block_delta", :index=>0, :delta=>{:type=>"text_delta", :text=>"."}}>
#<data Anthropic::Client::Response status="success", body={:type=>"content_block_stop", :index=>0}>
#<data Anthropic::Client::Response status="success", body={:type=>"message_delta", :delta=>{:stop_reason=>"end_turn", :stop_sequence=>nil}, :usage=>{:output_tokens=>23}}>
#<data Anthropic::Client::Response status="success", body={:type=>"message_stop"}>

# Or, if you just want to print the text content:
Anthropic.messages.create(**options) do |event|
  next unless event.body[:type] == 'content_block_delta'

  print event.body[:delta][:text]
end

# Output =>
# Hello! Not much up with me, I'm an AI assistant created by Anthropic.
```

You can also pass in a list of tools the assistant can use. You can find out more information about tools in the [documentation](https://docs.anthropic.com/claude/docs/tool-use).

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

Anthropic.messages.create(
  model: 'claude-3-opus-20240229',
  max_tokens: 200,
  tools:,
  messages: [{role: 'user', content: 'What is the weather like in Nashville?'}]
)
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
#<data Anthropic::Client::Response status="success", body={:type=>"completion", :id=>"compl_01Y9ptPR7xGHaH9rC3ffJExU", :completion=>" Hello! Not much going on here. How about you?", :stop_reason=>"stop_sequence", :model=>"claude-2.1", :stop=>"\n\nHuman:", :log_id=>"compl_01Y9ptPR7xGHaH9rC3ffJExU"}>
```

Alternatively, you can stream the response:

```ruby
options = {
  model: 'claude-2',
  max_tokens_to_sample: 200,
  prompt: 'Human: Yo what up?\n\nAssistant:',
  stream: true
}

Anthropic.completions.create(**options) do |event|
  puts event
end

# Output =>
#<data Anthropic::Client::Response status="success", body={:type=>"completion", :id=>"compl_015AktggW7tcM4w11YpkuMbP", :completion=>" Hello", :stop_reason=>nil, :model=>"claude-2.1", :stop=>nil, :log_id=>"compl_015AktggW7tcM4w11YpkuMbP"}>
#<data Anthropic::Client::Response status="success", body={:type=>"completion", :id=>"compl_015AktggW7tcM4w11YpkuMbP", :completion=>"!", :stop_reason=>nil, :model=>"claude-2.1", :stop=>nil, :log_id=>"compl_015AktggW7tcM4w11YpkuMbP"}>
#<data Anthropic::Client::Response status="success", body={:type=>"completion", :id=>"compl_015AktggW7tcM4w11YpkuMbP", :completion=>" Not", :stop_reason=>nil, :model=>"claude-2.1", :stop=>nil, :log_id=>"compl_015AktggW7tcM4w11YpkuMbP"}>
#<data Anthropic::Client::Response status="success", body={:type=>"completion", :id=>"compl_015AktggW7tcM4w11YpkuMbP", :completion=>" much", :stop_reason=>nil, :model=>"claude-2.1", :stop=>nil, :log_id=>"compl_015AktggW7tcM4w11YpkuMbP"}>
#<data Anthropic::Client::Response status="success", body={:type=>"completion", :id=>"compl_015AktggW7tcM4w11YpkuMbP", :completion=>" going", :stop_reason=>nil, :model=>"claude-2.1", :stop=>nil, :log_id=>"compl_015AktggW7tcM4w11YpkuMbP"}>
#<data Anthropic::Client::Response status="success", body={:type=>"completion", :id=>"compl_015AktggW7tcM4w11YpkuMbP", :completion=>" on", :stop_reason=>nil, :model=>"claude-2.1", :stop=>nil, :log_id=>"compl_015AktggW7tcM4w11YpkuMbP"}>
#<data Anthropic::Client::Response status="success", body={:type=>"completion", :id=>"compl_015AktggW7tcM4w11YpkuMbP", :completion=>" here", :stop_reason=>nil, :model=>"claude-2.1", :stop=>nil, :log_id=>"compl_015AktggW7tcM4w11YpkuMbP"}>
#<data Anthropic::Client::Response status="success", body={:type=>"completion", :id=>"compl_015AktggW7tcM4w11YpkuMbP", :completion=>".", :stop_reason=>nil, :model=>"claude-2.1", :stop=>nil, :log_id=>"compl_015AktggW7tcM4w11YpkuMbP"}>
#<data Anthropic::Client::Response status="success", body={:type=>"completion", :id=>"compl_015AktggW7tcM4w11YpkuMbP", :completion=>"", :stop_reason=>"stop_sequence", :model=>"claude-2.1", :stop=>"\n\nHuman:", :log_id=>"compl_015AktggW7tcM4w11YpkuMbP"}>

# Or, if you just want to print the text content:
Anthropic.completions.create(**options) do |event|
  print event.body[:completion]
end

# Output =>
# Hello! Not much, just chatting with you. How's it going?
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

