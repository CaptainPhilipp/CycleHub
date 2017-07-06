# frozen_string_literal: true

FactoryGirl.define do
  factory :children_parent do
    association :parent,   factory: :category
    association :children, factory: :category
  end
end
