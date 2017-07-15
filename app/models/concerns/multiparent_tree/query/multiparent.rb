# frozen_string_literal: true

module MultiparentTree
  module Query
    class Multiparent < Base
      def call
        query_for_alternatives
          .group(:id)
          .having('count(children_parents.parent_id) = ?', parents_count)
      end

      private

      def query_for_alternatives
        first_alternative  = condition_alternatives.shift
        other_alternatives = condition_alternatives

        other_alternatives
          .inject query_for(first_alternative) do |memorized_query, alternative|
            memorized_query.or query_for(alternative)
          end
      end

      def condition_alternatives
        @condition_alternatives ||=
          class_ids_associations.inject([]) do |alteratives, class_and_ids|
            klass = class_and_ids.first.to_s
            ids   = class_and_ids.last

            alteratives << { parent_id: ids,
                             parent_type: klass,
                             children_type: childs_type }
          end
      end

      def class_ids_associations
        parent_ids_by_class.to_a
      end
    end
  end
end
