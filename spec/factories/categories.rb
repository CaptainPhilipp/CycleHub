# frozen_string_literal: true

FactoryGirl.define do
  factory :category do
    ru_title { |i| "Русское название #{i}" }
    en_title { |i| "English title #{i}" }
    depth 1
  end
end
