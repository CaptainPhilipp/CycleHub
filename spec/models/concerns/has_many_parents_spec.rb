# frozen_string_literal: true

require 'rails_helper'

describe 'HasManyParents concern' do
  with_model :HasManyParentsDouble do
    table { |t| t.integer :depth; t.string :en_title }
    model { include HasManyParents }
  end

  with_model :AlienParentDouble do
    table { |t| t.integer :depth; t.string :en_title }
  end

  let(:parent)  { HasManyParentsDouble.create en_title: 'Parent' }
  let(:parent1) { HasManyParentsDouble.create en_title: 'Parent_1' }
  let(:parent2) { HasManyParentsDouble.create en_title: 'Parent_2' }
  let(:alien_parent) { AlienParentDouble.create en_title: 'Alien_parent' }

  let(:children)  { HasManyParentsDouble.create en_title: 'Children' }
  let(:children1) { HasManyParentsDouble.create en_title: 'Children_1' }
  let(:children2) { HasManyParentsDouble.create en_title: 'Children_2' }
  let(:children3) { HasManyParentsDouble.create en_title: 'Children_3' }

  describe '#add_parent' do
    let(:call_method) { children.add_parent parent }

    it 'should create join record' do
      expect { call_method }.to change(ChildrenParent, :count).by(1)
    end

    it 'created join record should have right relations' do
      call_method
      expect(ChildrenParent.last.parent_id).to eq parent.id
      expect(ChildrenParent.last.children_id).to eq children.id
    end
  end

  describe '#remove_parent' do
    let(:call_method) { children.remove_parent parent, parent1 }

    before { children.add_parent parent, parent1 }

    it 'should destroy join record' do
      expect { call_method }.to change(ChildrenParent, :count).by(-2)
    end
  end

  describe '.where_parents' do
    before do
      children.add_parents  parent, parent1, parent2
      children1.add_parents parent, parent1, parent2
      children2.add_parents parent, parent1,          alien_parent
      children3.add_parents parent,                   alien_parent
    end

    it 'children have chosen parents' do
      expect(HasManyParentsDouble.where_parents(parent))
        .to match_array [children, children1, children2, children3]

      expect(HasManyParentsDouble.where_parents(parent, parent1))
        .to match_array [children, children1, children2]

      expect(HasManyParentsDouble.where_parents(parent1, parent2))
        .to match_array [children, children1]

      expect(HasManyParentsDouble.where_parents(parent, parent1, parent2))
        .to match_array [children, children1]
    end

    it 'children have chosen parents when parent has many classes' do
      expect(HasManyParentsDouble.where_parents(parent, parent1, alien_parent))
        .to match_array [children2]
    end
  end
end
