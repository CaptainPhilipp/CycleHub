require 'rails_helper'

RSpec.describe Parameter, type: :model do
  it { should have_db_column :ru_title }
  it { should have_db_column :en_title }
  it { should have_db_column :deleted_at }
end
