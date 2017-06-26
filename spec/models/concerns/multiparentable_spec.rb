require 'rails_helper'

describe 'Multiparentable concern' do
  with_model :MultiparentableDouble do
    table { |t| t.integer :depth }
    model { include Multiparentable }
  end

  let(:parent0) { MultiparentableDouble.create }
  let(:parent1) { MultiparentableDouble.create }
  let(:parent2) { MultiparentableDouble.create }
  let(:parent3) { MultiparentableDouble.create }

  let(:children0) { MultiparentableDouble.create }
  let(:children1) { MultiparentableDouble.create }
  let(:children2) { MultiparentableDouble.create }
  let(:children3) { MultiparentableDouble.create }

  context do
    it 'add_parent'
    it 'remove_parent'
    it 'remove_children'
    it 'add_children'
  end

  context do
    before do
      parent0.add_children children0
      parent1.add_children children1
      parent2.add_children children1, children2
      parent3.add_children children1, children2, children3
    end

    describe '.where_parents' do
      it 'children should have equal parents' do
        expect(MultiparentableDouble.where_parents parent0).to match_array(children0)
        expect(MultiparentableDouble.where_parents parent1).to match_array(children1, children2, children3)
        expect(MultiparentableDouble.where_parents parent1, parent2).to match_array(children1, children2)
        expect(MultiparentableDouble.where_parents parent1, parent2, parent3).to match_array(children1)
      end

      it 'children should have equal parents' do
        expect(MultiparentableDouble.where_parents parent0).to match_array(children0)
        expect(MultiparentableDouble.where_parents parent1).to match_array(children1, children2, children3)
        expect(MultiparentableDouble.where_parents parent1, parent2).to match_array(children1, children2)
        expect(MultiparentableDouble.where_parents parent1, parent2, parent3).to match_array(children1)
      end
    end
  end
end
