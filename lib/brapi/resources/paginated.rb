# frozen_string_literal: true

module Brapi
  module Resources
    # Adds auto-pagination helpers (`#each_page`, `#each`) to a Resource around
    # an existing list-style method.
    #
    # Usage:
    #
    #   class Brapi::Resources::V2::Fii < Brapi::Resource
    #     include Brapi::Resources::Paginated
    #     paginates items: :fiis
    #
    #     def list(**params)
    #       # ...
    #     end
    #   end
    #
    # Two pagination shapes are supported:
    #
    # 1. Nested (FII / Treasury): the response has a `pagination` sub-object
    #    with `page` and `has_next_page`. This is the default.
    # 2. Flat (Quote#list): the response exposes `current_page` /
    #    `has_next_page` directly. Pass `has_next:` and `next_page:` lambdas
    #    to override the readers.
    #
    # A `max_pages:` keyword arg can be passed to `each_page` / `each` (or set
    # via the global `default_max_pages` argument to the macro) to cap the
    # walk — protects against runaway loops if the upstream forgets to set
    # `has_next_page = false`.
    module Paginated
      DEFAULT_MAX_PAGES = 10_000

      def self.included(base)
        base.include(Enumerable)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def paginates(items:, via: :list, has_next: nil, next_page: nil)
          has_next  ||= ->(resp) { resp.pagination&.has_next_page }
          next_page ||= ->(resp) { (resp.pagination&.page || 0) + 1 }

          define_each_page(via: via, has_next: has_next, next_page: next_page)
          define_each(items: items)
        end

        private

        def define_each_page(via:, has_next:, next_page:)
          define_method(:each_page) do |max_pages: Brapi::Resources::Paginated::DEFAULT_MAX_PAGES, **params, &block|
            return enum_for(:each_page, max_pages: max_pages, **params) unless block

            current = params.delete(:page) || 1
            pages_seen = 0
            loop do
              resp = public_send(via, **params, page: current)
              block.call(resp)
              pages_seen += 1
              break if pages_seen >= max_pages
              break unless has_next.call(resp)

              current = next_page.call(resp)
            end
          end
        end

        def define_each(items:)
          define_method(:each) do |max_pages: Brapi::Resources::Paginated::DEFAULT_MAX_PAGES, **params, &block|
            return enum_for(:each, max_pages: max_pages, **params) unless block

            each_page(max_pages: max_pages, **params) do |resp|
              resp.public_send(items).each { |item| block.call(item) }
            end
          end
        end
      end
    end
  end
end
