## ✨ anthropic-rb ✨

Ruby bindings for the Anthropic API. This library is unofficial and is not affiliated with Anthropic PBC.

The goal of this project is feature parity with Anthropic's Python SDK until an official Ruby SDK is available.

## Usage

anthropic-rb will default to the value of the `ANTHROPIC_API_KEY` environment variable. However, you may initialize the library with your API key:

```ruby
require 'anthropic-rb'

Anthropic.setup do |config|
  config.api_key = 'YOUR_API_KEY'
end
```

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

