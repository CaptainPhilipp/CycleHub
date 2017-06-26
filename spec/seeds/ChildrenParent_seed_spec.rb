require 'rails_helper'

RSpec.describe ChildrenParentSeed do
  let(:args) {  }
  let(:call) { ChildrenParentSeed.new(args).call }

  it 'Should create Category' do
    expect { call }.to change(ChildrenParent, :count).by(1)
  end
end
