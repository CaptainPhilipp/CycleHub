require 'rails_helper'

RSpec.describe CategorySeed do
  let(:args) {  }
  let(:call) { CategorySeed.new(args).call }

  it 'Should create Category' do
    expect { call }.to change(Category, :count).by(1)
  end
end
