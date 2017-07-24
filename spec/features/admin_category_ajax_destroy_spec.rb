# frozen_string_literal: true

require 'feature_helper'

feature 'Admin category ajax destroy spec', type: :feature do
  let(:attributes)  { attributes_for :category }
  let!(:category) { create :category }

  scenario 'Admin tries to destroy category', :js do
    visit admin_categories_path

    within "#edit_row_#{category.id}" do
      expect(page).to have_content category.en_title
      click_on 'Delete'
    end

    expect(page).to_not have_content category.en_title
  end
end
