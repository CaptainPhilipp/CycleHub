# frozen_string_literal: true

require 'rails_helper'

describe 'ByDepth collection service object' do
  describe '#grouped' do
    let(:collection) { create_list :category, 3 }
    let(:service)    { Collection::ByDeep.new(collection) }

    context 'when only one depth' do
      it 'returns a hash' do
        expect(service.grouped).to be_a Hash
      end

      it 'hash have right size' do
        expect(service.grouped.size).to eq 1
      end
    end

    context 'when collection have a few depths' do
      let(:collection) { create_list(:category, 7) + create_list(:category, 3, depth: 0) }

      it 'hash have right size' do
        expect(service.grouped.size).to eq 2
      end
    end
  end
end
