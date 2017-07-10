# frozen_string_literal: true

class Category < ApplicationRecord
  include HasManyChilds
  include HasManyParents

  has_many :childs_dy_depth1,
           -> { where depth: 1 },
           through: :children_associations,
           source_type: 'Category',
           source: :children

  scope :includes_tree, -> { where(depth: 0).includes childs_dy_depth1: :children_categories }
  scope :has_depth,     -> { where.not(depth: nil) }
  scope :last_update,   -> { order(:updated_at).limit(1).pluck(:updated_at) }

  before_save :update_short_title

  def title(locale)
    send "#{locale}_title"
  end

  private

  def update_short_title
    new_short_title = en_title.downcase.gsub(/\sand\s/, '-n-').tr(' ', '-')
    return if new_short_title == short_title
    self.short_title = new_short_title
  end
end
