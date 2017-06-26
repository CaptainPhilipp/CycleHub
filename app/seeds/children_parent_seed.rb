class ChildrenParentSeed < AbstractSeed
  def call
    ChildrenParent.create(arguments)
  end
end
