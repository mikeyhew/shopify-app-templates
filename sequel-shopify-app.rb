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

after_bundle do
  git :init
  git add: '.'
  git commit: '-m initial'
end
