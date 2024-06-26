# frozen_string_literal: true

RSpec.describe Anthropic::Client::Streaming do
  describe '.post' do
    subject(:send_request) { described_class.post(url, body) { |event| events << event } }

    let(:url) { 'https://foo.bar/baz' }
    let(:body) { "data: #{event.to_json}" }
    let(:events) { [] }

    include_examples 'handles errors from the API'

    context 'when event type is ping' do
      let(:event) { { type: 'ping' } }

      it 'does not yield the event to the block' do
        stub_http_request(:post, url).to_return(status: 200, body:)
        send_request
        expect(events).to be_empty
      end
    end

    context 'when event type is error' do
      let(:event) do
        {
          type: 'error',
          error: {
            type: 'invalid_request_error',
            message: 'There was an issue with the format or content of your request.'
          }
        }
      end

      it 'does not yield the event to the block' do
        stub_http_request(:post, url).to_return(status: 200, body:)
        send_request
        expect(events).to be_empty
      end
    end

    context 'when event type is message_start' do
      let(:event) do
        {
          type: 'message_start',
          message: {
            id: 'msg_1nZdL29xx5MUA1yADyHTEsnR8uuvGzszyY',
            type: 'message',
            role: 'assistant',
            content: [],
            model: 'claude-3-opus-20240229',
            stop_reason: nil,
            stop_sequence: nil
          },
          usage: {
            input_tokens: 25,
            output_tokens: 1
          }
        }
      end

      it 'yields the response to the block' do
        stub_http_request(:post, url).to_return(status: 200, body:)
        send_request
        expect(events).to eq([Anthropic::Client::Response.new('success', event)])
      end
    end

    context 'when event type is content_block_start' do
      let(:event) do
        {
          type: 'content_block_start',
          index: 0,
          content_block: {
            type: 'text',
            text: ''
          }
        }
      end

      it 'yields the response to the block' do
        stub_http_request(:post, url).to_return(status: 200, body:)
        send_request
        expect(events).to eq([Anthropic::Client::Response.new('success', event)])
      end
    end

    context 'when event type is content_block_delta' do
      let(:event) do
        {
          type: 'content_block_delta',
          index: 0,
          delta: {
            type: 'text_delta',
            text: 'Hello'
          }
        }
      end

      it 'yields the response to the block' do
        stub_http_request(:post, url).to_return(status: 200, body:)
        send_request
        expect(events).to eq([Anthropic::Client::Response.new('success', event)])
      end
    end

    context 'when event type is content_block_stop' do
      let(:event) { { type: 'content_block_stop', index: 0 } }

      it 'yields the response to the block' do
        stub_http_request(:post, url).to_return(status: 200, body:)
        send_request
        expect(events).to eq([Anthropic::Client::Response.new('success', event)])
      end
    end

    context 'when event type is message_delta' do
      let(:event) do
        {
          type: 'message_delta',
          delta: {
            stop_reason: 'end_turn',
            stop_sequence: nil
          },
          usage: {
            output_tokens: 15
          }
        }
      end

      it 'yields the response to the block' do
        stub_http_request(:post, url).to_return(status: 200, body:)
        send_request
        expect(events).to eq([Anthropic::Client::Response.new('success', event)])
      end
    end

    context 'when event type is message_stop' do
      let(:event) { { type: 'message_stop' } }

      it 'yields the response to the block' do
        stub_http_request(:post, url).to_return(status: 200, body:)
        send_request
        expect(events).to eq([Anthropic::Client::Response.new('success', event)])
      end
    end
  end
end
