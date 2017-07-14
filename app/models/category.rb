# frozen_string_literal: true

class Category < ApplicationRecord
  include HasManyChilds
  include HasManyParents

  def title(locale)
    send "#{locale}_title"
  end
end
