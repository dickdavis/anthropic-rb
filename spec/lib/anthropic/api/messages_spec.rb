# frozen_string_literal: true

RSpec.describe Anthropic::Api::Messages do
  subject(:messages_api) { described_class.new }

  before do
    Anthropic.setup do |config|
      config.api_key = 'foo'
    end
  end

  describe '#create' do
    subject(:call_method) { messages_api.create(**params) }

    shared_examples 'validates the params against the specified API version'

    context 'with beta option flagged' do
      subject(:call_method) { described_class.new(beta: 'tools-2024-04-04').create(**params) }

      let(:params) do
        {
          model: 'claude-2.1',
          messages: [{ role: 'user', content: 'foo' }],
          tools:,
          max_tokens: 200
        }
      end

      let(:tools) do
        [
          {
            name: 'foo',
            description: 'bar',
            input_schema: {
              foo: 'bar'
            }
          }
        ]
      end

      it 'sends the beta header' do
        stub_http_request(:post, 'https://api.anthropic.com/v1/messages').to_return(status: 200, body: '{}')
        call_method
        expect(WebMock)
          .to have_requested(:post, 'https://api.anthropic.com/v1/messages')
          .with(headers: { 'anthropic-beta' => 'tools-2024-04-04' })
      end
    end

    context 'with valid params' do
      # rubocop:disable RSpec/NestedGroups
      context 'when stream option is set to true' do
        subject(:call_method) { messages_api.create(**params) { |event| events << event } }

        let(:params) do
          {
            model: 'claude-2.1',
            messages: [{ role: 'user', content: 'foo' }],
            max_tokens: 200,
            stream: true
          }
        end
        let(:body) do
          [
            'data: {"type":"message_start", "message":{"id":"msg_012pkeozZynwyNvSagwL7kMw", "type":"message", "role":"assistant", "content":[], "model":"claude-2.1", "stop_reason":null, "stop_sequence":null}}', # rubocop:disable Layout/LineLength
            'data: {"type":"content_block_start", "index":0, "content_block":{"type":"text", "text":""}}',
            'data: {"type":"content_block_delta", "index":0, "delta":{"type":"text_delta", "text":"Hello"}}',
            'data: {"type":"content_block_delta", "index":0, "delta":{"type":"text_delta", "text":"."}}',
            'data: {"type":"content_block_stop", "index":0}',
            'data: {"type":"message_delta", "delta":{"stop_reason":"end_turn", "stop_sequence":null}}',
            'data: {"type":"message_stop"}'
          ].join("\r\n")
        end

        let(:events) { [] }
        let(:expected_events) do
          [
            { type: 'message_start',
              message: { id: 'msg_012pkeozZynwyNvSagwL7kMw', type: 'message', role: 'assistant', content: [],
                         model: 'claude-2.1', stop_reason: nil, stop_sequence: nil } },
            { type: 'content_block_start', index: 0, content_block: { type: 'text', text: '' } },
            { type: 'content_block_delta', index: 0, delta: { type: 'text_delta', text: 'Hello' } },
            { type: 'content_block_delta', index: 0, delta: { type: 'text_delta', text: '.' } },
            { type: 'content_block_stop', index: 0 },
            { type: 'message_delta', delta: { stop_reason: 'end_turn', stop_sequence: nil } },
            { type: 'message_stop' }
          ]
        end

        before do
          stub_http_request(:post, 'https://api.anthropic.com/v1/messages').to_return(status: 200, body:)
        end

        it 'receives streamed events' do
          call_method
          aggregate_failures do
            expect(events.map(&:status).uniq).to eq(['success'])
            expect(events.map(&:body)).to eq(expected_events)
          end
        end
      end

      context 'when stream option is set to false or not provided' do
        let(:params) do
          {
            model: 'claude-2.1',
            messages: [{ role: 'user', content: 'foo' }],
            max_tokens: 200
          }
        end
        let(:response_body) do
          {
            id: 'msg_013ePdwEkb4RMC1hCE61Hbm8',
            type: 'message',
            role: 'assistant',
            content: [{ type: 'text', text: 'Hello! Not much up with me, just chatting. How about you?' }],
            model: 'claude-2.1',
            stop_reason: 'end_turn',
            stop_sequence: nil
          }
        end

        before do
          stub_http_request(:post, 'https://api.anthropic.com/v1/messages').and_return(
            status: 200,
            body: JSON.generate(response_body)
          )
        end

        it 'returns the response from the API' do
          response = call_method
          aggregate_failures do
            expect(response.status).to eq('success')
            expect(response.body).to eq(response_body)
          end
        end
      end
      # rubocop:enable RSpec/NestedGroups
    end
  end
end
