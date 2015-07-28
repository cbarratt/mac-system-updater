require 'spec_helper'
require 'system'

RSpec.describe RVM do
  subject { RVM::installed? }

  describe '#installed?' do
    it 'should return true if RVM is installed' do
      allow(File).to receive(:exist?).and_return(true)

      expect(subject).to eq(true)
    end

    it 'should return false if RVM is not installed' do
      allow(File).to receive(:exist?).and_return(false)

      expect(subject).to eq(false)
    end
  end
end
