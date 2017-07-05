# frozen_string_literal: true

require 'rails_helper'

describe 'ByDepth collection service object' do
  describe '#grouped' do
    let(:collection) { create_list :category }
    let(:object) { Collection::ByDeep.new(collection) }

    context 'when only one depth' do
      it 'returns a hash' do
        expect(object.grouped).to be_a Hash
      end

      it 'hash have right size' do
        expect(object.grouped.size).to eq 1
      end
    end

    context 'when collection have a few depths' do
      let(:collection) { create_list(:category) << create_list(:category, depth: 0) }

      it 'hash have right size' do
        expect(object.grouped.size).to eq 2
      end
    end
  end
end
