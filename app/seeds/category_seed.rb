# frozen_string_literal: true

# Abstract dump management (Create, Validate, Release)
class CategorySeed < AbstractSeed
  class << self
    # db records, that was valid in past, but now becomes outdated and invalid
    def find_outdated(scope = nil)
      scope ||= model
      invalid_records = []
      scope.find_each { |record| invalid_records << record unless record.valid? }
      invalid_records
    end

    alias find_invalid_db_records find_outdated

    # dump if there are no invalid records
    def valid_dump!(scope = nil)
      validate_db_records!(scope)
      hashlist = model.all.map { |record| map(record) }
      write_dump(hashlist)
    end

    # validate last saved dump
    def dump_valid?
      hashlist = deserialize(read_last_dump)
      validate_hashlist(hashlist)
    end

    # release dump
    def seed
      hashlist = deserialize(read_last_dump)
      populate_with hashlist
    end

    protected

    # should return Hash with params
    def map(record)
      record.serializable_hash.delete_if { |key, _| %i[id created_at updated_at].include? key }
    end

    private

    def validate_db_records!(scope = nil)
      invalid_records = find_outdated(scope)
      raise InvalidRecordFinded, invalid_records if invalid_records.any?
    end

    def write_dump(hashlist)
      new_dump.write serialize(hashlist)
    end

    def read_last_dump
      File.open dumpfile_adress(base_dump_filename)
    end

    def populate_with(hashlist)
      model.create! hashlist
    end

    def validate_serialized(hashlist)
      hashlist.all? do |hash|
        hash.delete('id')
        model.new(hash).valid?
      end
    end

    def deserialize(data)
      JSON.parse data
    end

    def serialize(data)
      data.to_json
    end

    def new_dump
      filepath = dumpfile_adress(base_dump_filename)
      File.new(filepath, 'w+')
    end

    def base_dump_filename
      @base_dump_filename ||= model_type.tableize
    end

    def dumpfile_adress(filename)
      Rails.root.join("app/seeds/dump/#{filename}.dump")
    end

    def model
      @model ||= model_type.constantize
    end

    def model_type
      return @model_type if @model_type
      to_s =~ /([A-Z]\w*)Seed/
      @model_type = $1
    end
  end

  class InvalidRecordFinded < RuntimeError; end
end
