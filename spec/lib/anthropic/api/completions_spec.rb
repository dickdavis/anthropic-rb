# frozen_string_literal: true

RSpec.describe Anthropic::Api::Completions do
  subject(:completions_api) { described_class.new }

  before do
    Anthropic.setup do |config|
      config.api_key = 'foo'
    end
  end

  describe '#create' do
    subject(:call_method) { completions_api.create(**params) }

    shared_examples 'validates the params against the specified API version'

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

        before do
          stub_http_request(:post, 'https://api.anthropic.com/v1/complete').to_return(status: 200, body:)
        end

        it 'receives streamed events' do
          call_method
          aggregate_failures do
            expect(events.map(&:status).uniq).to eq(%w[success])
            expect(events.map(&:body)).to eq([{ bar: 'foo' }])
          end
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

        before do
          stub_http_request(:post, 'https://api.anthropic.com/v1/complete').and_return(
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
