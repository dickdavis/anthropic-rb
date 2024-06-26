# frozen_string_literal: true

RSpec.shared_examples 'validates the params against the specified API version' do
  context 'with invalid params' do
    let(:params) { { model: 'foo' } }

    it 'raises an Anthropic::Api:SchemaValidationError' do
      expect { call_method }.to raise_error(Anthropic::Api::SchemaValidationError)
    end
  end

  context 'with invalid API version configured' do
    it 'raises an Anthropic::Api::UnsupportedApiVersionError' do
      allow(Anthropic).to receive(:api_version).and_return('2023-06-02')
      expect { call_method }.to raise_error(Anthropic::Api::UnsupportedApiVersionError)
    end
  end
end
