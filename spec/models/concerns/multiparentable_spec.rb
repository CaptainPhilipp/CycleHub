require 'rails_helper'

describe 'Multiparentable concern' do
  with_model :MultiparentableDouble do
    table { |t| t.integer :depth }
    model { include Multiparentable }
  end

  let(:parent)  { MultiparentableDouble.create }
  let(:parent1) { MultiparentableDouble.create }
  let(:parent2) { MultiparentableDouble.create }
  let(:parent3) { MultiparentableDouble.create }

  let(:children)  { MultiparentableDouble.create }
  let(:children1) { MultiparentableDouble.create }
  let(:children2) { MultiparentableDouble.create }
  let(:children3) { MultiparentableDouble.create }

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
    let(:call_method) { parent.remove_children children }

    before { parent.add_children children }

    it 'should destroy join record' do
      expect { call_method }.to change(ChildrenParent, :count).by(-1)
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
    let(:call_method) { children.remove_parent parent }

    before { parent.add_children children }

    it 'should destroy join record' do
      expect { call_method }.to change(ChildrenParent, :count).by(-1)
    end
  end

  describe '.where_parents' do
    before do
      parent.add_children  children, children1, children2, children3
      parent1.add_children children, children1, children2
      parent2.add_children children, children1
      parent3.add_children children
    end

    it 'children should have equal parents v1 (loose)' do
      # expect(MultiparentableDouble.where_parents parent)
      #   .to match_array [children, children1, children2, children3]
      #
      # expect(MultiparentableDouble.where_parents parent, parent1)
      #   .to match_array [children, children1, children2]

      expect(MultiparentableDouble.where_parents parent1, parent2)
        .to match_array [children, children1]

      # expect(MultiparentableDouble.where_parents parent, parent1, parent2)
      #   .to match_array [children, children1]
      #
      # expect(MultiparentableDouble.where_parents parent, parent1, parent2, parent3)
      #   .to match_array [children]
    end

    it 'children should have equal parents v2 (strict)' do
      expect(MultiparentableDouble.where_parents parent1, parent2)
        .to match_array [children1]
    end
  end
end
