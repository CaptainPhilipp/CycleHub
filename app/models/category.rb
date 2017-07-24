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

  before_save :change_short_title

  def title(locale)
    send "#{locale}_title"
  end

  def self.cache_key
    order(updated_at: :desc).take.cache_key
  end

  private

  def change_short_title
    return unless short_title.nil? || short_title.empty?
    self.short_title = en_title.downcase.gsub(/\sand\s/, '-n-').tr(' ', '-')
  end
end
