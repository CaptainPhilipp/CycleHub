class CategorySeed < AbstractSeed
  def call
    Category.create(arguments)
  end
end
