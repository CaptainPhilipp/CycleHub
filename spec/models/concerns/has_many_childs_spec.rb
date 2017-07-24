# frozen_string_literal: true

require 'rails_helper'

describe 'HasManyChilds concern' do
  with_model :HasManyChildsDouble do
    table { |t| t.integer :depth; t.string :en_title }
    model { include HasManyChilds }
  end

  let(:parent)  { HasManyChildsDouble.create en_title: 'Parent' }
  let(:children)  { HasManyChildsDouble.create en_title: 'Children' }
  let(:children1) { HasManyChildsDouble.create en_title: 'Children_1' }

  describe '#add_children' do
    let(:call_method) { parent.add_children children }

    it 'should create join record' do
      expect { call_method }.to change(ChildrenParent, :count).by(1)
    end

    it 'created join record should have right relations' do
      call_method
      expect(ChildrenParent.last.parent_id).to eq parent.id
      expect(ChildrenParent.last.children_id).to eq children.id
    end
  end

  describe '#remove_children' do
    let(:call_method) { parent.remove_children children, children1 }

    before { parent.add_children children, children1 }

    it 'should destroy join record' do
      expect { call_method }.to change(ChildrenParent, :count).by(-2)
    end
  end
end
