# frozen_string_literal: true

module Categories
  class Serializer
    DELIMETER = ':'
    REGEXP    = DELIMETER

    def initialize(string)
      @identificators_string = string
    end

    def string
      @identificators_string if values_type
    end

    def values_type
      @values_type ||=
        case @identificators_string
        when /\A[\d#{REGEXP}]*[^A-z]\z/ then :id
        when /\A[A-z#{REGEXP}\-]*\z/    then :short_title
        end
    end

    def values
      @identificators ||=
        if    short_titles? then string_array
        elsif ids?          then string_array.map(&:to_i)
        end
    end

    def short_titles?
      values_type == :short_title
    end

    def ids?
      values_type == :id
    end

    def short_titles
      @short_titles ||= short_titles? && identificators
    end

    def ids
      @ids ||= ids? && identificators
    end

    def valid?
      @valid ||= values_type ? true : false
    end

    def cache_key
      string
    end

    class << self
      def serialize_to_ids(*categories, ids: nil)
        ids ||= categories.map(&:id)
        ids.join(DELIMETER)
      end

      def serialize_to_short_titles(*categories, titles: nil)
        titles ||= categories.map(&:short_title)
        titles.join(DELIMETER)
      end
    end

    private

    def string_array
      string&.split(DELIMETER)
    end
  end
end
