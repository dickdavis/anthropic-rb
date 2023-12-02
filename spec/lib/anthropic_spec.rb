# frozen_string_literal: true

RSpec.describe Anthropic do
  it 'has a version number' do
    expect(Anthropic::VERSION).not_to be_nil
  end

  describe '.setup' do
    subject(:setup) do
      described_class.setup do |anthropic|
        anthropic.api_key = api_key
      end
    end

    let(:api_key) { 'foobar' }

    it 'sets the provided values' do
      setup
      expect(described_class.api_key).to eq(api_key)
    end
  end

  describe '.api_key' do
    subject(:call_method) { described_class.api_key }

    let(:api_key) { 'foobar' }

    before do
      described_class.api_key = api_key
    end

    it 'returns the API key' do
      expect(call_method).to eq(api_key)
    end
  end

  describe '.api_key=' do
    subject(:call_method) { described_class.api_key = api_key }

    let(:api_key) { 'foobar' }

    it 'returns the API key' do
      call_method
      expect(described_class.api_key).to eq(api_key)
    end
  end
end
