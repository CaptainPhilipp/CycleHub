module Admin
  class CategoriesController < BaseController
    before_action :load_category, only: %i(update destroy)

    def index
      @categories = Category.order(:created_at)
      @category = Category.new
    end

    def tree
      categories = Category.where.not(depth: nil)
      @categories_by_deep = Collection::ByDeep.new(categories)
    end

    def create
      @category = Category.create(category_params)
    end

    def update
      @category.update(category_params)
    end

    def destroy
      @category.destroy
    end

    private

    def category_params
      params.require(:category).permit %i(ru_title en_title depth)
    end

    def load_category
      @category = Category.find(params[:id])
    end
  end
end
