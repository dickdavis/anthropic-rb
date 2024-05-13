# frozen_string_literal: true

RSpec.describe Anthropic::Client do
  shared_examples 'handles errors from the API' do
    context 'with 400 response' do
      let(:event) do
        {
          type: 'error',
          error: {
            type: 'invalid_request_error',
            message: 'There was an issue with the format or content of your request.'
          }
        }
      end

      it 'raises an Anthropic::Errors::InvalidRequestError' do
        stub_http_request(:post, url).and_return(status: 400, body:)
        expect { send_request }.to raise_error(Anthropic::Errors::InvalidRequestError)
      end
    end

    context 'with 401 response' do
      let(:event) do
        {
          type: 'error',
          error: {
            type: 'authentication_error',
            message: 'There’s an issue with your API key.'
          }
        }
      end

      it 'raises an Anthropic::Errors::AuthenticationError' do
        stub_http_request(:post, url).and_return(status: 401, body:)
        expect { send_request }.to raise_error(Anthropic::Errors::AuthenticationError)
      end
    end

    context 'with 403 response' do
      let(:event) do
        {
          type: 'error',
          error: {
            type: 'permission_error',
            message: 'Your API key does not have permission to use the specified resource.'
          }
        }
      end

      it 'raises an Anthropic::Errors::PermissionError' do
        stub_http_request(:post, url).and_return(status: 403, body:)
        expect { send_request }.to raise_error(Anthropic::Errors::PermissionError)
      end
    end

    context 'with 404 response' do
      let(:event) do
        {
          type: 'error',
          error: {
            type: 'not_found_error',
            message: 'The requested resource was not found.'
          }
        }
      end

      it 'raises an Anthropic::Errors::NotFoundError' do
        stub_http_request(:post, url).and_return(status: 404, body:)
        expect { send_request }.to raise_error(Anthropic::Errors::NotFoundError)
      end
    end

    context 'with 409 response' do
      let(:event) do
        {
          type: 'error',
          error: {
            type: 'invalid_request_error',
            message: 'There was an issue with the format or content of your request.'
          }
        }
      end

      it 'raises an Anthropic::Errors::ConflictError' do
        stub_http_request(:post, url).and_return(status: 409, body:)
        expect { send_request }.to raise_error(Anthropic::Errors::ConflictError)
      end
    end

    context 'with 422 response' do
      let(:event) do
        {
          type: 'error',
          error: {
            type: 'invalid_request_error',
            message: 'There was an issue with the format or content of your request.'
          }
        }
      end

      it 'raises an Anthropic::Errors::UnprocessableEntityError' do
        stub_http_request(:post, url).and_return(status: 422, body:)
        expect { send_request }.to raise_error(Anthropic::Errors::UnprocessableEntityError)
      end
    end

    context 'with 429 response' do
      let(:event) do
        {
          type: 'error',
          error: {
            type: 'rate_limit_error',
            message: 'Your account has hit a rate limit.'
          }
        }
      end

      it 'raises an Anthropic::Errors::RateLimitError' do
        stub_http_request(:post, url).and_return(status: 429, body:)
        expect { send_request }.to raise_error(Anthropic::Errors::RateLimitError)
      end
    end

    context 'with 500 response' do
      let(:event) do
        {
          type: 'error',
          error: {
            type: 'api_error',
            message: 'An unexpected error has occurred internal to Anthropic’s systems.'
          }
        }
      end

      it 'raises an Anthropic::Errors::ApiError' do
        stub_http_request(:post, url).and_return(status: 500, body:)
        expect { send_request }.to raise_error(Anthropic::Errors::ApiError)
      end
    end

    context 'with 529 response' do
      let(:event) do
        {
          type: 'error',
          error: {
            type: 'overloaded_error',
            message: 'Anthropic’s API is temporarily overloaded.'
          }
        }
      end

      it 'raises an Anthropic::Errors::OverloadedError' do
        stub_http_request(:post, url).and_return(status: 529, body:)
        expect { send_request }.to raise_error(Anthropic::Errors::OverloadedError)
      end
    end
  end

  describe '.post' do
    subject(:send_request) { described_class.post(url, data) }

    let(:url) { 'https://foo.bar/baz' }
    let(:data) { { foo: 'bar' } }
    let(:body) { JSON.generate(event) }

    include_examples 'handles errors from the API'

    context 'with successful response' do
      let(:event) do
        {
          content: 'foo',
          id: 'foo',
          model: 'bar',
          role: 'assistant',
          stop_reason: 'baz',
          stop_sequence: 'foobar',
          type: 'message',
          usage: 'foobarba'
        }
      end

      it 'returns the response body' do
        stub_http_request(:post, url).and_return(status: 200, body:)
        expect(send_request).to eq(Anthropic::Client::Response.new('success', event))
      end
    end
  end

  describe '.post_as_stream' do
    subject(:send_request) { described_class.post_as_stream(url, body) { |event| events << event } }

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
