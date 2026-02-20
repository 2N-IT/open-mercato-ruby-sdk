# frozen_string_literal: true

module OpenMercato
  module Resources
    module Customers
      class Comment < Resource
        api_path "/api/customers/comments"

        attribute :id, :string
        attribute :commentable_id, :string
        attribute :commentable_type, :string
        attribute :body, :string
        attribute :author_id, :string
        attribute :created_at, :string
        attribute :updated_at, :string
      end
    end
  end
end
