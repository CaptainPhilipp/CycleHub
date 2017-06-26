class AbstractSeed
  def initialize(args = {})
    @arguments = args
  end

  def call
    raise NotImplementedError
  end

  private

  attr_reader :arguments
end
