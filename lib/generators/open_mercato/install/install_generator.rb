# frozen_string_literal: true

require "rails/generators"

module OpenMercato
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Install Open Mercato SDK: creates initializer and webhook handler"

      def copy_initializer
        template "initializer.rb.tt", "config/initializers/open_mercato.rb"
      end

      def copy_webhook_handlers
        template "webhook_handlers.rb.tt", "app/services/open_mercato_handlers.rb"
      end

      def mount_engine
        route 'mount OpenMercato::Engine, at: "/open_mercato"'
      end

      def show_readme
        say ""
        say "Open Mercato SDK installed!", :green
        say ""
        say "Next steps:"
        say "  1. Set your environment variables (OPEN_MERCATO_URL, OPEN_MERCATO_API_KEY, etc.)"
        say "  2. Edit config/initializers/open_mercato.rb"
        say "  3. Edit app/services/open_mercato_handlers.rb to handle webhooks"
        say ""
      end
    end
  end
end
