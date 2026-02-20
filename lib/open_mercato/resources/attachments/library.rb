# frozen_string_literal: true

module OpenMercato
  module Resources
    module Attachments
      class Library < Resource
        api_path "/api/attachments/library"

        attribute :id,               :string
        attribute :file_name,        :string
        attribute :file_size,        :integer
        attribute :mime_type,        :string
        attribute :partition_code,   :string
        attribute :partition_title,  :string
        attribute :url,              :string
        attribute :thumbnail_url,    :string
        attribute :tags,             :string # JSON array as string
        attribute :content,          :string
        attribute :created_at,       :string
      end
    end
  end
end
