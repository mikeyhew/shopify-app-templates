String.send :define_method, :deindent do
  indent = match(/ */)[0]
  gsub /^ {#{indent.length}}/, ''
end

def source_paths
  ["#{__dir__}/polaris-rails",
   "#{__dir__}/sequel"]
end

insert_into_file "Gemfile", "\nruby '#{RUBY_VERSION}'", after: "source 'https://rubygems.org'\n"

gem 'webpacker'
gem 'shopify_app', '~> 8.2'
gem 'shopify_app_mixins', github: 'mikeyhew/shopify_app_mixins'
gem 'shopify_api', '~> 4.9'
gem 'shopify_api_mixins', github: 'mikeyhew/shopify_api_mixins'
gem 'activeresource', github: 'rails/activeresource'
gem 'sequel', '~> 5.1'
gem 'pg'
gem 'sequel_pg', require: false
gem 'sequel-rails', github: 'Talentbox/sequel-rails'

gem 'pry'
gem 'pry-rails'

gem_group :development, :test do
 gem 'dotenv-rails'
 gem 'pry-byebug'
 gem 'pry-rescue'
end

def generate_shop_model
  generate :model, 'shop', 'shopify_domain:string:uniq', 'shopify_token:string', '--no-migration'
  copy_file 'shop_model.rb','app/models/shop.rb', force: true
  copy_file "shop_migration.rb", "db/migrate/#{Time.now.utc.strftime('%Y%m%d%H%M%S')}_create_shops.rb"
end

def generate_embedded_app_controller
  remove_file "app/views/layouts/embedded_app.html.erb"
  remove_file "app/views/layouts/_flash_messages.html.erb"

  copy_file "embedded_app.html.erb", "app/views/embedded_app/index.html.erb"

  generate :controller, "embedded_app", "index", "--no-assets", "--skip-routes", "--skip"

  gsub_file "app/controllers/embedded_app_controller.rb", "< ApplicationController", "< ShopifyApp::AuthenticatedController"

  # ShopifyApp::AuthenticatedController uses layout "embedded_app", need to get rid of it
  insert_into_file "app/controllers/embedded_app_controller.rb", "  layout false\n\n", after: "class EmbeddedAppController < ShopifyApp::AuthenticatedController\n"
end


after_bundle do
  # keep spring from hanging during development
  # of this template
  run 'bin/spring stop'

  git :init
  git add: "."
  git commit: '-a -m "initial commit with gems"'

  append_to_file "config/application.rb", <<-CODE.deindent.prepend("\n")
    # force ssl across the whole app (including ShopifyApp stuff), while still letting some controllers override it
    ActionController::Base.force_ssl
  CODE

  # add Procfile
  file "Procfile", <<-CODE.deindent
    web: bundle exec puma -C config/puma.rb
  CODE

  # use shopify_api_mixins
  initializer "shopify_api.rb", <<-CODE.deindent
    ShopifyAPI::Connection.retry_on_429
    ShopifyAPI::Connection.retry_on_5xx
  CODE

  template 'database.yml.erb', 'config/database.yml'

  # add the wildcard first, so it
  # ends up at the bottom
  route "get '*wildcard', to: 'embedded_app#index'"

  generate 'shopify_app:install'

  route "root 'embedded_app#index'"

  copy_file 'shopify_app_initializer.rb', 'config/initializers/shopify_app.rb', force: true

  generate_shop_model

  generate_embedded_app_controller

  # set up Webpacker, and add yarn dependencies
  rails_command "webpacker:install"
  rails_command "webpacker:install:react"
  # use react v15 until Polaris supports v16
  run "yarn add react@15 react-dom@15"
  run "yarn add @shopify/polaris react-router react-router-dom"

  gsub_file "config/webpacker.yml", "https: false", "https: true"

  copy_file "components.jsx", "app/javascript/components.jsx"
  copy_file "Page.jsx", "app/javascript/Page.jsx"
  remove_file "app/javascript/packs/application.js"
  copy_file "application.js", "app/javascript/packs/application.js"

  # use environment variables for shopify config
  # this has to be at the end, so other rails commands can run
  gsub_file 'config/initializers/shopify_app.rb', '"<api_key>"', 'ENV.fetch("SHOPIFY_API_KEY")'
  gsub_file 'config/initializers/shopify_app.rb', '"<secret>"', 'ENV.fetch("SHOPIFY_SECRET")'

  append_to_file '.gitignore', ".env\n"

  git add: "."
  git commit: '-a -m "generate everything else"'

  file '.env', "SHOPIFY_API_KEY\nSHOPIFY_SECRET\n"

  puts "\n\nAlmost done! Enter you app name and port for puma-dev"

  puma_dev_app = app_name.gsub(/_/, '')
  answer = ask "app name for puma-dev (#{puma_dev_app}):"
  puma_dev_app = answer if answer.present?

  port = ask("PORT for puma-dev (e.g. 3005):") until port.present?

  run "echo #{port} > ~/.puma-dev/#{puma_dev_app}"
  append_to_file '.env', "PORT=#{port}\n"

  app_url = "https://#{puma_dev_app}.dev"

  puts <<-MESSAGE.deindent
    Congrats, you have created a new Polaris app with Sequel. You still have one more thing to do before it will run, though:

    - create an app in your Shopify Partner's Dashboard, and do the following:
      - enable the Embedded App extension
      - set the app url to #{app_url}
      - set the OAuth callback url to #{app_url}/auth/shopify_callback
      - copy the api key and secret, and paste them into .env

    - create your database and run migrations with `rake db:create db:migrate`

    Once you've done all that, you can run your app with `rails s` and `bin/webpack-dev-server`
  MESSAGE
end
