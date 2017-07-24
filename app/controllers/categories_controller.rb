class CategoriesController < ApplicationController
  include CategoriesHelper

  before_action :load_categories, only: [:show]
  before_action :load_articles

  def index
    @parameters = Parameter.where_parent_ids(serialized.ids, klass: Category)
  end

  def show
    @parameters = Parameter.where_parents(@categories)
  end

  private

  def load_articles
    @articles = ('A'..'Z').to_a.map { |i| Article.new(title: "Some title #{i}") }
  end

  def load_categories
    return unless serialized.valid?
    @categories = Category.where(serialized.values_type => serialized.values)
                          .order(:depth)
                          .uniq(&:depth)
  end

  def serialized
    @serialized ||= Categories::Serializer.new params[:id]
  end
end
