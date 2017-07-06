# frozen_string_literal: true

require 'rails_helper'

describe 'RelativesIds service object' do
  describe '#classes_for(object)' do
    let(:category) { create :category }
    let(:children) { create :category }
    let(:parent)   { create :category }

    let(:collection) do
      [create(:children_parent, children: category, parent: parent),
       create(:children_parent, children: children, parent: category)]
    end

    let(:service) { Collection::RelativesIds.new(collection) }

    it 'have right parent' do
      expect(service.classes_for(category)).to include("children-of-#{parent.id}")
    end

    it 'have right children' do
      expect(service.classes_for(category)).to include("parent-of-#{children.id}")
    end
  end
end
