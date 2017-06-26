class AbstractSeed
  def initialize(args = {})
    @arguments = args
  end

  def create
    raise NotImplementedError
  end

  private

  attr_reader :arguments
end
