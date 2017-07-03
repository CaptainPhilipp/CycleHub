class Category < ApplicationRecord
  include Multiparentable

  def title(locale)
    send "#{locale}_title"
  end
end
