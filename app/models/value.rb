class Value < ApplicationRecord
  include HasManyParents

  def parameters_where_parents(*parents)
    Parameter.where_parents(self, *parents)
  end
end
