# frozen_string_literal: true

module OpenMercato
  class Collection
    include Enumerable

    attr_reader :items, :total, :page, :page_size, :total_pages

    def initialize(response, resource_class)
      @items = (response["items"] || []).map { |attrs| resource_class.new(attrs) }
      @total = response["total"] || 0
      @page = response["page"] || 1
      @page_size = response["pageSize"] || 25
      @total_pages = response["totalPages"] || 1
    end

    def each(&) = items.each(&)
    def next_page? = page < total_pages
    def prev_page? = page > 1
  end
end
