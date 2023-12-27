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

    let(:api_key) { 'test' }

    after do
      described_class.reset
    end

    it 'sets the provided values' do
      setup
      expect(described_class.api_key).to eq(api_key)
    end
  end

  describe '.api_key' do
    subject(:call_method) { described_class.api_key }

    context 'when no API key has been set' do
      # rubocop:disable RSpec/NestedGroups
      context 'with the ANTHROPIC_API_KEY environment variable set' do
        let(:api_key) { 'foobar' }

        it 'returns the API key from the environment variable' do
          allow(ENV).to receive(:fetch).with('ANTHROPIC_API_KEY', nil).and_return(api_key)
          expect(call_method).to eq(api_key)
        end
      end

      context 'without the ANTHROPIC_API_KEY environment variable' do
        it 'returns nil' do
          allow(ENV).to receive(:fetch).with('ANTHROPIC_API_KEY', nil).and_return(nil)
          expect(call_method).to be_nil
        end
      end
      # rubocop:enable RSpec/NestedGroups
    end

    context 'when an API key has been set' do
      let(:api_key) { 'foobar' }

      it 'returns the API key' do
        described_class.api_key = api_key
        expect(call_method).to eq(api_key)
      end
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

    context 'when the version has not been set' do
      # rubocop:disable RSpec/NestedGroups
      context 'with the ANTHROPIC_API_VERSION environment variable set' do
        let(:api_version) { '2023-12-25' }

        it 'returns the API version from the environment variable' do
          allow(ENV).to receive(:fetch).with('ANTHROPIC_API_VERSION', '2023-06-01').and_return(api_version)
          expect(call_method).to eq(api_version)
        end
      end

      context 'without the ANTHROPIC_API_VERSION environment variable' do
        it 'returns the default API version' do
          allow(ENV).to receive(:fetch).with('ANTHROPIC_API_VERSION', '2023-06-01').and_return('2023-06-01')
          expect(call_method).to eq('2023-06-01')
        end
      end
      # rubocop:enable RSpec/NestedGroups
    end

    context 'when the version has been set' do
      let(:api_version) { '2023-12-25' }

      it 'returns the API version' do
        described_class.api_version = api_version
        expect(call_method).to eq(api_version)
      end
    end
  end

  describe '.api_version=' do
    subject(:call_method) { described_class.api_version = api_version }

    let(:api_version) { '2023-12-25' }

    it 'sets the API version' do
      call_method
      expect(described_class.api_version).to eq(api_version)
    end
  end
end
