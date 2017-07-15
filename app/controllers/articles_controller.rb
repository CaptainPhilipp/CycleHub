class ArticlesController < ApplicationController

  def index
    @parameters = Parameter.where_parent_ids([], klass: Category)
    @articles   = [Article.new(title: 'Some title')]
  end
end
