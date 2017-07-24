class Parameter < ApplicationRecord
  include HasManyParents
  include HasManyChilds

  VALUE_TYPES = %w[ListValueInt ListValueString RangeValue].freeze

  validates :value_type, inclusion: { in: VALUE_TYPES }

  def values
    values_class.where_parents(self).close_relative
  end

  def values_where_parents(*parents)
    values_class.where_parents(self, *parents).close_relative
  end

  private

  def values_class
    values_type.constantize
  end
end
