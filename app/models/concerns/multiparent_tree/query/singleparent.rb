# frozen_string_literal: true

module MultiparentTree
  module Query
    class Singleparent < Base
      def call
        query_for parent_id: parents_ids, parent_type: parents_type, children_type: childs_type
      end
    end
  end
end
