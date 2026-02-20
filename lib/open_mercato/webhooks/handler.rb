# frozen_string_literal: true

module OpenMercato
  module Webhooks
    class Handler
      class << self
        def on(pattern, callable = nil, &block)
          handler = callable || block
          raise ArgumentError, "Handler or block required" unless handler

          handlers[pattern] ||= []
          handlers[pattern] << handler
        end

        def dispatch(event)
          matching_handlers(event.type).each do |handler|
            handler.call(event)
          end
        end

        def clear!
          @handlers = {}
        end

        private

        def handlers
          @handlers ||= {}
        end

        def matching_handlers(event_type)
          handlers.each_with_object([]) do |(pattern, pattern_handlers), matched|
            matched.concat(pattern_handlers) if pattern_matches?(pattern, event_type)
          end
        end

        def pattern_matches?(pattern, event_type)
          return true if pattern == "*"

          if pattern.end_with?(".*")
            prefix = pattern.chomp(".*")
            event_type.start_with?("#{prefix}.")
          else
            pattern == event_type
          end
        end
      end
    end
  end
end
