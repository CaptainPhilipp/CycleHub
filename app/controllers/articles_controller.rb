class ArticlesController < ApplicationController
  def index
    @parameters = Parameter.where_parents()
  end
end
