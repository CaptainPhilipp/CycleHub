module CategoriesHelper
  def build_path_for(*categories)
    category_path Categories::Serializer.serialize_to_short_titles(*categories)
  end
end
