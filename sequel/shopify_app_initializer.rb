ShopifyApp::SessionRepository.send :define_singleton_method, :load_storage do
  Shop
end

ShopifyApp.configure do |config|
  config.application_name = "My Sequel Shopify App"
  config.embedded_app = true
  config.api_key = "<api_key>"
  config.secret = "<secret>"
  config.scope = 'write_products, write_orders'
  config.after_authenticate_job = false
  # webhooks_hostname = ENV.fetch 'WEBHOOKS_HOSTNAME'
  # config.webhooks = [
  #   # {topic: 'orders/create', address: "https://\#{webhooks_hostname}/webhooks/new_order"}
  # ]
end
