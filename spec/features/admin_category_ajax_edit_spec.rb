# frozen_string_literal: true

require 'feature_helper'

feature 'Admin category ajax edit spec', type: :feature do
  let(:attributes)  { attributes_for :category }
  let!(:category) { create :category }

  scenario 'Admin tries to edit with form', :js do
    visit root_path

    find("#edit_row_#{category.id}").click

    within "#edit_form_#{category.id}" do
      fill_in 'category_en_title', with: attributes[:en_title]
      fill_in 'category_ru_title', with: attributes[:ru_title]
      click_on 'update'
    end

    expect(page).to_not have_content category.en_title

    within "#edit_row_#{category.id}" do
      expect(page).to have_content attributes[:en_title]
    end
  end

  # TODO: fix js
  xscenario 'Admin tries to edit with form twice', :js do
    visit root_path

    find("#edit_row_#{category.id}").click
    within "#edit_form_#{category.id}" do
      click_on 'update'
    end

    find("#edit_row_#{category.id}").click
    within "#edit_form_#{category.id}" do
      fill_in 'category_en_title', with: attributes[:en_title]
      fill_in 'category_ru_title', with: attributes[:ru_title]
      click_on 'update'
    end

    expect(page).to_not have_content category.en_title
    expect(page).to have_content attributes[:en_title]
  end
end
