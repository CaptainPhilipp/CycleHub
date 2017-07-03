module Collection
  class DeepCollection
    class WrongDepth < RuntimeError; end
    attr_reader :collection

    def initialize(collection)
      @collection = collection
    end

    def grouped
      @grouped_collection ||= collection.group_by(&:depth)
    end

    def by_depth(depth)
      grouped.fetch convert_depth(depth)
    end

    def depths
      @depths ||= grouped.keys
    end

    private

    def convert_depth(depth)
      case depth
      when Integer         then depth
      when 'nil'           then nil
      when String, /[0-9]/ then depth.to_i
      else raise WrongDepth
      end
    end
  end
end
