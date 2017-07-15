# frozen_string_literal: true

module MultiparentTree
  module Query
    class Base
      def initialize(childs_object:, parents_object:)
        @parents_collection = parents_object
        @childs_type_object = childs_object
      end

      def call
        raise NotImplementedError
      end

      private

      def query_for(conditions)
        childs_class
          .joins(:parent_associations)
          .where(children_parents: conditions)
      end

      # Depedencies isolation

      def childs_class
        @childs_type_object.klass
      end

      def childs_type
        @childs_type_object.type
      end

      def parents_ids
        @parents_collection.ids
      end

      def parents_type
        @parents_collection.type
      end

      def parents_count
        @parents_collection.count
      end

      def parent_ids_by_class
        @parents_collection.ids_by_class
      end
    end
  end
end
