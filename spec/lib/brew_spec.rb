require 'spec_helper'
require 'system'

RSpec.describe Brew do
  subject { Brew.installed? }

  describe '#installed?' do
    it 'should return true if homebrew is installed' do
      allow(File).to receive(:exist?).and_return(true)

      expect(subject).to eq(true)
    end

    it 'should return false if homebrew is not installed' do
      allow(File).to receive(:exist?).and_return(false)

      expect(subject).to eq(false)
    end
  end
end
