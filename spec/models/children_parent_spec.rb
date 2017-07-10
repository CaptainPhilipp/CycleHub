# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChildrenParent, type: :model do
  it { should have_db_column :parent_id }
  it { should have_db_column :parent_type }
  it { should have_db_column :children_id }
  it { should have_db_column :children_type }
end
