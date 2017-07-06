# frozen_string_literal: true

class CategorySeed < AbstractSeed
  def create
    Category.create(arguments)
  end
end
