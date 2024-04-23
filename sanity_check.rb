# frozen_string_literal: true

require 'anthropic'

Anthropic.setup do |config|
  config.api_key = ENV.fetch('ANTHROPIC_API_KEY')
end

puts "\nTesting non-streaming messages API"
puts Anthropic.messages.create(
  model: 'claude-2.1',
  max_tokens: 200,
  messages: [{ role: 'user', content: 'Yo what up?' }]
)

puts "\nTesting streaming messages API"
Anthropic.messages.create(
  model: 'claude-2.1',
  max_tokens: 200,
  messages: [{ role: 'user', content: 'Yo what up?' }],
  stream: true
) { |event| puts event }

puts "\nTesting tools beta"
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

puts Anthropic.messages(beta: 'tools-2024-04-04').create(
  model: 'claude-3-opus-20240229',
  max_tokens: 200,
  tools:,
  messages: [{ role: 'user', content: 'What is the weather like in Nashville?' }]
)

puts "\nTesting completions API"
puts Anthropic.completions.create(
  model: 'claude-2',
  max_tokens_to_sample: 200,
  prompt: 'Human: Yo what up?\n\nAssistant:'
)

puts "\nTesting streaming completions API"
Anthropic.completions.create(
  model: 'claude-2',
  max_tokens_to_sample: 200,
  prompt: 'Human: Yo what up?\n\nAssistant:',
  stream: true
) { |event| puts event }
