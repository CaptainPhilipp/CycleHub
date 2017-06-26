require 'rails_helper'

RSpec.describe CategorySeed do
  let(:args) { {} }

  let(:seed) { CategorySeed.new(args) }
  let(:call_create) { seed.create }
  let(:times) { 10 }
  let(:call_times) { seed.times(times) }

  context '#create' do
    it 'Should create record' do
      expect { call_create }.to change(Category, :count).by(1)
    end

    it 'Should return record' do
      expect(call_create).to be_a Category
    end

    it 'should be valid' do
      expect(call_create).to be_valid
    end
  end
end
