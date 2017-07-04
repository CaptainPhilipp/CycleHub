require 'feature_helper'

RSpec.feature 'Admin category ajax create spec', type: :feature do
  let(:attributes) { attributes_for :category }

  fscenario 'Admin creates a category with form', js: true do
    visit admin_categories_path

    within '#new_category_path' do
      save_and_open_page
      fill_in '#category_en_title', with: attributes[:en_title]
      fill_in '#category_ru_title', with: attributes[:ru_title]
      click_on 'Create Category'
    end

    expect(page).to have_content attributes[:en_title]
  end
end
