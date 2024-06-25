# frozen_string_literal: true

RSpec.shared_examples 'handles errors from the API' do
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
