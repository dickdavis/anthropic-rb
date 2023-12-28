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
      # rubocop:disable RSpec/NestedGroups
      context 'when stream option is set to true' do
        subject(:call_method) { completions_api.create(**params) { |event| events << event } }

        let(:params) do
          {
            model: 'claude-2.1',
            prompt: 'foo',
            max_tokens_to_sample: 1,
            stream: true
          }
        end
        let(:body) { 'data: {"bar":"foo"}' }
        let(:events) { [] }

        it 'raises an error if the API version is not supported' do
          allow(Anthropic).to receive(:api_version).and_return('2023-06-02')
          expect { call_method }.to raise_error(Anthropic::Completions::UnsupportedApiVersionError)
        end

        it 'receives streamed events' do
          stub_http_request(:post, 'https://api.anthropic.com/v1/complete').to_return(status: 200, body:)
          call_method
          expect(events).to eq([{ bar: 'foo' }])
        end
      end

      context 'when stream option is set to false or not provided' do
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

        it 'raises an error if the API version is not supported' do
          allow(Anthropic).to receive(:api_version).and_return('2023-06-02')
          expect { call_method }.to raise_error(Anthropic::Completions::UnsupportedApiVersionError)
        end

        it 'returns the response from the API' do
          stub_http_request(:post, 'https://api.anthropic.com/v1/complete').and_return(
            status: 200,
            body: JSON.generate(response_body)
          )
          expect(call_method).to eq(response_body)
        end
      end
      # rubocop:enable RSpec/NestedGroups
    end
  end
end
