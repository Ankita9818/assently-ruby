require "assently/id_generator"

module Assently
  class Case
    def self.signature_types
      [ "sms", "electronicid", "touch", "quickintent", "signbyhand" ]
    end

    attr_reader :name, :signature_types, :id

    def initialize name, signature_types, id: nil
      @name = name
      @id = id || IdGenerator.generate
      self.signature_types = signature_types
    end

    def signature_types= signature_types
      types = Array(signature_types)

      unknown_types = types - Case.signature_types
      if unknown_types.any?
        raise unknown_signature_type_error(unknown_types)
      end

      @signature_types = types
    end

    def add_party party
      self.parties << party
    end

    def parties
      @parties ||= []
    end

    def add_document document
      self.documents << document
    end

    def documents
      @documents ||= []
    end

    private

    def unknown_signature_type_error types
      ArgumentError.new("Unknown signature types: #{types.join(", ")}. Valid types are: #{Case.signature_types.join(", ")}")
    end
  end
end
