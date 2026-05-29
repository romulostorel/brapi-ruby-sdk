# frozen_string_literal: true

module Brapi
  module Resources
    # Adds auto-pagination helpers (`#each_page`, `#each`, plus a fast
    # `#count` / `#size`) to a Resource around an existing list-style method.
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
    # ## Requirements on the host
    #
    # The list-style method named by `via:` (default `:list`) must accept a
    # `page:` keyword argument. The mixin sets this on every iteration to walk
    # through pages; if the host's `list` rejects `page:` the first iteration
    # will raise `ArgumentError`.
    #
    # ## Pagination shapes
    #
    # Two shapes are supported:
    #
    # 1. **Nested** (FII / Treasury): the response has a `pagination` sub-object
    #    with `page`, `has_next_page`, `total_items`. This is the default.
    # 2. **Flat** (Quote#list): the response exposes `current_page` /
    #    `has_next_page` / `item_count` directly. Pass `has_next:`, `next_page:`
    #    and `count_from:` lambdas to override the readers.
    #
    # ## Safety
    #
    # `max_pages:` (default `DEFAULT_MAX_PAGES`) caps any walk — protects
    # against runaway loops if the upstream forgets to set
    # `has_next_page = false`. The cap is checked **before** each fetch so
    # `max_pages: 0` yields nothing.
    #
    # ## #count behaviour
    #
    # When called with no args and no block, `#count` fetches **only the first
    # page** and reads `pagination.total_items` (or whatever `count_from:`
    # returns), avoiding a full walk. When called with an item or a block, it
    # delegates to the standard `Enumerable#count` (which walks every page).
    module Paginated
      DEFAULT_MAX_PAGES = 10_000

      def self.included(base)
        base.include(Enumerable)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def paginates(items:, via: :list, has_next: nil, next_page: nil, count_from: nil)
          has_next   ||= ->(resp) { resp.pagination&.has_next_page }
          next_page  ||= ->(resp) { (resp.pagination&.page || 0) + 1 }
          count_from ||= ->(resp) { resp.pagination&.total_items }

          define_each_page(via: via, has_next: has_next, next_page: next_page)
          define_each(items: items)
          define_count(via: via, count_from: count_from)
        end

        private

        def define_each_page(via:, has_next:, next_page:)
          define_method(:each_page) do |max_pages: Brapi::Resources::Paginated::DEFAULT_MAX_PAGES, **params, &block|
            return enum_for(:each_page, max_pages: max_pages, **params) unless block

            current = params.delete(:page) || 1
            pages_seen = 0
            loop do
              break if pages_seen >= max_pages

              resp = public_send(via, **params, page: current)
              block.call(resp)
              pages_seen += 1
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

        def define_count(via:, count_from:)
          define_method(:count) do |*args, &block|
            # count(item) and count { block } use Enumerable's filtering
            # semantics — fall back to the standard walk.
            return super(*args, &block) unless args.empty? && block.nil?

            total = count_from.call(public_send(via, page: 1))
            total.nil? ? super(*args, &block) : total
          end

          define_method(:size) { count }
        end
      end
    end
  end
end
