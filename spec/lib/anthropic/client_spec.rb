# frozen_string_literal: true

RSpec.describe Anthropic::Client do
  describe '.post' do
    subject(:send_request) { described_class.post(url, data) }

    let(:url) { 'https://foo.bar/baz' }
    let(:data) { { foo: 'bar' } }
    let(:body) { { bar: 'foo' } }

    context 'with successful response' do
      it 'returns the response body' do
        stub_http_request(:post, 'https://foo.bar/baz').and_return(status: 200, body: JSON.generate(body))
        expect(send_request).to eq(body)
      end
    end

    context 'with 400 response' do
      it 'raises an Anthropic::BadRequestError' do
        stub_http_request(:post, 'https://foo.bar/baz').and_return(status: 400, body: JSON.generate(body))
        expect { send_request }.to raise_error(Anthropic::BadRequestError)
      end
    end

    context 'with 401 response' do
      it 'raises an Anthropic::AuthenticationError' do
        stub_http_request(:post, 'https://foo.bar/baz').and_return(status: 401, body: JSON.generate(body))
        expect { send_request }.to raise_error(Anthropic::AuthenticationError)
      end
    end

    context 'with 403 response' do
      it 'raises an Anthropic::PermissionDeniedError' do
        stub_http_request(:post, 'https://foo.bar/baz').and_return(status: 403, body: JSON.generate(body))
        expect { send_request }.to raise_error(Anthropic::PermissionDeniedError)
      end
    end

    context 'with 404 response' do
      it 'raises an Anthropic::NotFoundError' do
        stub_http_request(:post, 'https://foo.bar/baz').and_return(status: 404, body: JSON.generate(body))
        expect { send_request }.to raise_error(Anthropic::NotFoundError)
      end
    end

    context 'with 409 response' do
      it 'raises an Anthropic::ConflictError' do
        stub_http_request(:post, 'https://foo.bar/baz').and_return(status: 409, body: JSON.generate(body))
        expect { send_request }.to raise_error(Anthropic::ConflictError)
      end
    end

    context 'with 422 response' do
      it 'raises an Anthropic::UnprocessableEntityError' do
        stub_http_request(:post, 'https://foo.bar/baz').and_return(status: 422, body: JSON.generate(body))
        expect { send_request }.to raise_error(Anthropic::UnprocessableEntityError)
      end
    end

    context 'with 429 response' do
      it 'raises an Anthropic::RateLimitError' do
        stub_http_request(:post, 'https://foo.bar/baz').and_return(status: 429, body: JSON.generate(body))
        expect { send_request }.to raise_error(Anthropic::RateLimitError)
      end
    end

    context 'with 500 response' do
      it 'raises an Anthropic::InternalServerError' do
        stub_http_request(:post, 'https://foo.bar/baz').and_return(status: 500, body: JSON.generate(body))
        expect { send_request }.to raise_error(Anthropic::InternalServerError)
      end
    end
  end
end
