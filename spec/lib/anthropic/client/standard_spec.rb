# frozen_string_literal: true

RSpec.describe Anthropic::Client::Standard do
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
end
