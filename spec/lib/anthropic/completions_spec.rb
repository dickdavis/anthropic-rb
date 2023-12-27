# frozen_string_literal: true

RSpec.describe Anthropic::Completions do
  subject(:completions_api) { described_class.new }

  describe '#create' do
    subject(:call_method) { completions_api.create(**params) }

    context 'with invalid params' do
      let(:params) { { model: 'foo' } }

      it 'raises an error' do
        expect { call_method }.to raise_error(ArgumentError)
      end
    end

    context 'with valid params' do
      let(:params) do
        {
          model: 'claude-2.1',
          prompt: 'foo',
          max_tokens_to_sample: 1
        }
      end
      let(:response_body) do
        {
          id: 'compl_0123',
          type: 'completion',
          completion: 'bar',
          stop_reason: 'stop_sequence',
          model: 'claude-2.1'
        }
      end

      before do
        stub_http_request(:post, 'https://api.anthropic.com/v1/complete').and_return(
          status: 200,
          body: JSON.generate(response_body)
        )
      end

      it 'raises an error if the API version is not supported' do
        allow(Anthropic).to receive(:api_version).and_return('2023-06-02')
        expect { call_method }.to raise_error(Anthropic::Completions::UnsupportedApiVersionError)
      end

      it 'returns the response from the API' do
        expect(call_method).to eq(response_body)
      end
    end
  end
end
