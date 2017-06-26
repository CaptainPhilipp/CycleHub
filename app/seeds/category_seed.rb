class CategorySeed < AbstractSeed
  def create
    Category.create(arguments)
  end
end
