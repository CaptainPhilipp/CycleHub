# frozen_string_literal: true

module Value
  class Depth
    NIL = 'nil'

    def initialize(input = nil)
      @depth =
        case input
        when nil             then NIL
        when String, Integer then input
        else input.depth
        end
    end

    def value
      @depth
    end

    def ru_title
      title(:ru)
    end

    def en_title
      title(:en)
    end

    def title(locale)
      self.class.title(depth, locale)
    end

    def options_for_select(locale)
      self.class.options_for_select(locale)
    end

    class << self
      def options_for_select(locale)
        [[title(NIL, locale), nil],
         [title(0,   locale), 0],
         [title(1,   locale), 1],
         [title(2,   locale), 2]]
      end

      def title(depth, locale)
        I18n.t(depth_key(depth), scope: 'category.attributes.depth_index', locale: locale)
      end

      private

      def depth_key(depth)
        depth == NIL ? NIL : "depth_#{depth}"
      end
    end

    private

    attr_reader :depth
  end
end
