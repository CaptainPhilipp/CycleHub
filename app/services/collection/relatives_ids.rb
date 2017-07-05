module Collection
  # generates list of css classes like `parent-of-5 children-of-43`
  class RelativesIds
    def initialize(records)
      @records = records
    end

    def get_classes_for(object)
      parents_for(object.id) << ' ' << childs_for(object.id)
    end

    private

    attr_reader :records

    def parents_for(id)
      children_parents[id].map { |parent| "children-of-#{parent}" } * ' '
    end

    def childs_for(id)
      children_parents[id].map { |children| "parent-of-#{children}" } * ' '
    end

    def parent_childrens
      @parent_childrens ||= records_to_h(parent_id: [:children_id])
    end

    def children_parents
      @children_parents ||= records_to_h(children_id: [:parent_id])
    end

    def records_to_h(**arguments) # arguments like parent_id: :children_id
      check_arguments_count(arguments)
      key_method = arguments.keys.first
      value_method = arguments[key_name].first
      hash = {}

      records.each do |r|
        hash[r.send key_method] ||= []
        hash[r.send key_method] << r.send(value_method)
      end
      hash
    end

    def check_arguments_count(arguments)
      raise HashArgumentError unless arguments.size == 1
    end

    # custom exception
    class HashArgumentError < ArgumentError
      def exception
        'Only one `key: :value` argument!'
      end
    end
  end
end
