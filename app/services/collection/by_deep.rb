module Collection
  class ByDeep
    class WrongDepth < RuntimeError; end
    attr_reader :collection

    def initialize(collection)
      @collection = collection
    end

    def each_group(&block)
      depths.each do |depth|
        group = grouped[depth]
        yield(group, depth)
      end
    end

    private

    def depths
      @depths ||= grouped.keys.sort
    end

    def grouped
      @grouped_collection ||= collection.group_by(&:depth)
    end

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
