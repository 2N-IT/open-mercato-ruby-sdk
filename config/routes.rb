# frozen_string_literal: true

OpenMercato::Engine.routes.draw do
  post "webhooks", to: "webhooks#create"
end
