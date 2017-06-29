module Multiparentable
  extend ActiveSupport::Concern

  included do
    include HasManyChilds
    include HasManyParents
  end
end
