# frozen_string_literal: true

RSpec.describe Anthropic::Bootstrapper do
  describe '.load_betas' do
    subject(:call_method) { described_class.load_betas }

    it 'loads the tools-2024-04-04 beta' do
      expect(call_method.first['id']).to eq('tools-2024-04-04')
    end
  end

  describe '.load_versions' do
    subject(:call_method) { described_class.load_versions }

    it 'loads the versions from all subdirectories' do
      expect(call_method.keys).to match_array(%i[completions messages])
    end

    it 'loads the correct number of versions for completions API' do
      expect(call_method[:completions].size).to eq(1)
    end

    it 'loads the correct number of versions for messages API' do
      expect(call_method[:messages].size).to eq(1)
    end
  end
end
