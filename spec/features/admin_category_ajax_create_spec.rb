# frozen_string_literal: true

require 'feature_helper'

feature 'Admin category ajax create spec', type: :feature do
  let(:attributes) { attributes_for :category }

  scenario 'Admin creates a category with form', :js do
    visit root_path

    fill_in 'category_en_title', with: attributes[:en_title]
    fill_in 'category_ru_title', with: attributes[:ru_title]
    click_on 'Create Category'

    expect(page).to have_content attributes[:en_title]
    expect(page).to have_content attributes[:en_title]
  end
end
