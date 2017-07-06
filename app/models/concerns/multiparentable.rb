# frozen_string_literal: true

module Multiparentable
  extend ActiveSupport::Concern

  included do
    include HasManyChilds
    include HasManyParents
  end
end
