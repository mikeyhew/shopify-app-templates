gem 'sequel'
gem 'pg'
gem 'sequel-rails', git: 'https://github.com/TalentBox/sequel-rails.git'
gem 'activeresource', git: 'https://github.com/rails/activeresource'
gem 'shopify_api'
gem 'shopify_api_mixins', git: 'https://github.com/mikeyhew/shopify_api_mixins'
gem 'shopify_app'

initializer "shopify_api.rb", <<-CODE
ShopifyAPI::Connection.retry_on_429
ShopifyAPI::Connection.retry_on_5xx
CODE

file "config/database.yml", <<-CODE
default: &default
  adapter: postgresql
  port: 5432
  encoding: unicode
  pool: 5

development:
  <<: *default
  url: 'postgres://localhost/#{app_name}_development'

test:
  <<: *default
  url: 'postgres://localhost/#{app_name}_test'

production:
  <<: *default
  url: <%= ENV['DATABASE_URL'] %>
CODE

initializer "shopify_app.rb", <<-CODE
ShopifyApp::SessionRepository.send :define_method, :storage do
  Shop
end

ShopifyApp.configure do |config|
  config.embedded_app = true
  config.api_key = ENV['SHOPIFY_API_KEY']
  config.secret = ENV['SHOPIFY_SECRET']
  config.scope = 'write_products, write_orders'
  # webhooks_hostname = ENV['WEBHOOKS_HOSTNAME']
  # raise "Missing WEBHOOKS_HOSTNAME" unless webhooks_hostname.present?
  # config.webhooks = [
  #   # {topic: 'orders/create', address: "https://\#{ENV['WEBHOOKS_HOSTNAME']}/webhooks/new_order"}
  # ]
end
CODE

after_bundle do
  run 'bin/spring stop' # sometimes it hangs if you don't do this
  git :init
  git add: '.'
  git commit: '-m initial'
end
