# frozen_string_literal: true

module OpenMercato
  module Resources
    module Dictionaries
      class Dictionary < Resource
        api_path "/api/dictionaries"

        attribute :id, :string
        attribute :name, :string
        attribute :slug, :string
        attribute :description, :string
        attribute :is_system, :boolean
        attribute :created_at, :string
        attribute :updated_at, :string
      end
    end
  end
end
