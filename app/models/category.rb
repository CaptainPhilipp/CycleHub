class Category < ApplicationRecord
  include Multiparentable

  def depth_name
    I18n.t (depth || 'nil'), scope: 'category.attributes.depth_index', locale: :en
  end
end
