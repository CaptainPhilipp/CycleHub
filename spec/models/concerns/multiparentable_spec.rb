require 'rails_helper'

describe 'Multiparentable concern' do
  with_model :MultiparentableDouble do
    table { |t| t.integer :depth; t.string :en_title }
    model { include Multiparentable }
  end

  with_model :AlienDouble do
    table { |t| t.integer :depth; t.string :en_title }
    model { include Multiparentable }
  end

  let(:parent)  { MultiparentableDouble.create en_title: 'Parent' }
  let(:parent1) { MultiparentableDouble.create en_title: 'Parent_1' }
  let(:parent2) { MultiparentableDouble.create en_title: 'Parent_2' }
  let(:alien) { MultiparentableDouble.create en_title: 'Alien_parent' }

  let(:children)  { MultiparentableDouble.create en_title: 'Children' }
  let(:children1) { MultiparentableDouble.create en_title: 'Children_1' }
  let(:children2) { MultiparentableDouble.create en_title: 'Children_2' }
  let(:children3) { MultiparentableDouble.create en_title: 'Children_3' }

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
      parent.add_children  children, children1, children2, children3
      parent1.add_children children, children1, children2
      parent2.add_children children, children1
      alien.add_children                        children2, children3
    end

    it 'children should have equal parents' do
      expect(MultiparentableDouble.where_parents parent)
        .to match_array [children, children1, children2, children3]

      expect(MultiparentableDouble.where_parents parent, parent1)
        .to match_array [children, children1, children2]

      expect(MultiparentableDouble.where_parents parent1, parent2)
        .to match_array [children, children1]

      expect(MultiparentableDouble.where_parents parent, parent1, parent2)
        .to match_array [children, children1]

      expect(MultiparentableDouble.where_parents alien, parent, parent1)
        .to match_array [children2]
    end
  end
end
