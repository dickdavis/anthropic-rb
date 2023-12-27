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

    it 'sets the API key' do
      call_method
      expect(described_class.api_key).to eq(api_key)
    end
  end

  describe '.api_version' do
    subject(:call_method) { described_class.api_version }

    let(:api_version) { '2023-06-01' }

    before do
      described_class.api_version = api_version
    end

    it 'returns the API version' do
      expect(call_method).to eq(api_version)
    end
  end

  describe '.api_version=' do
    subject(:call_method) { described_class.api_version = api_version }

    context 'when the version is nil' do
      let(:api_version) { nil }

      it 'sets the default API version' do
        call_method
        expect(described_class.api_version).to eq('2023-06-01')
      end
    end

    context 'when the version is provided' do
      let(:api_version) { '2023-12-25' }

      it 'sets the API version' do
        call_method
        expect(described_class.api_version).to eq(api_version)
      end
    end
  end
end
