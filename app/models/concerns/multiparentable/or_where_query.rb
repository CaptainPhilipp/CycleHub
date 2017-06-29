module Multiparentable
  class OrWhereQuery
    def initialize(model, params_variants:)
      @constant = model
      @params_variants = params_variants
      raise 'params_variants must be Array of Hash' unless @params_variants.all? { |e| e.respond_to? 'keys' }
    end

    def start_query(query = nil)
      @query_where ||= query || constant.where(params_variants.shift)
    end

    def call
      params_variants
        .inject(start_query) do |memorized, data|
          memorized.or(constant.where data)
        end
    end

    private

    attr_reader :constant, :params_variants
  end
end
