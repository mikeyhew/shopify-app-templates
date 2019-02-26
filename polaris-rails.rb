# Usage: rails new -d postgresql --skip-turbolinks --skip-javascript --skip-action-cable -m shopify-app-templates/polaris-rails.rb <app_name>

def source_paths
  [__dir__]
end

gem 'webpacker', '~> 4.0.0.rc.7'
gem 'shopify_app'
gem 'shopify_api'

gem 'pry'
gem 'pry-rails'

gem_group :development, :test do
 gem 'dotenv-rails'
end

after_bundle do
  # keep spring from hanging during development
  # of this template
  run 'bin/spring stop'

  git :init
  git add: "."
  git commit: '-a -m "initial commit with gems"'

  # use https everywhere throughout the app
  application "config.force_ssl = true"

  # add Procfile
  file "Procfile", <<~CODE
    web: bundle exec puma -C config/puma.rb
  CODE

  # add Procfile.dev so we can use stuff like Foreman or Heroku Local
  file "Procfile.dev", <<~CODE
    rails: bundle exec rails s
    webpack: bundle exec bin/webpack-dev-server
  CODE

  # helper method for connecting to Shop in console
  file ".pryrc", <<~CODE
    Shop.send :define_method, :connect do
      session = ShopifyAPI::Session.new(shopify_domain, shopify_token)
      ShopifyAPI::Base.activate_session(session)
    end
  CODE

  # create a single controller with a single action and view for the single-paged app
  copy_file "app/views/embedded_app/index.html.erb"
  copy_file "app/helpers/embedded_app_helper.rb"
  generate :controller, "embedded_app", "index", "--no-assets", "--skip-routes", "--skip"
  gsub_file "app/controllers/embedded_app_controller.rb", "< ApplicationController", "< ShopifyApp::AuthenticatedController"
  insert_into_file "app/controllers/embedded_app_controller.rb", "  layout false\n\n", after: "class EmbeddedAppController < ShopifyApp::AuthenticatedController\n"
  route "get '*wildcard', to: 'embedded_app#index'"
  route "root 'embedded_app#index'"

  generate 'shopify_app:install'
  remove_file "app/views/layouts/embedded_app.html.erb"
  remove_file "app/views/layouts/_flash_messages.html.erb"

  generate 'shopify_app:shop_model'

  # copy JS files
  copy_file "app/javascript/App.tsx"
  copy_file "app/javascript/redux.ts"
  copy_file "app/javascript/packs/embedded_app.tsx"

  # set up webpack and loaders for react and typescript
  rails_command "webpacker:install"
  remove_file "app/javascript/packs/application.js"
  rails_command "webpacker:install:react"
  remove_file "app/javascript/packs/hello_react.jsx"
  rails_command "webpacker:install:typescript"
  remove_file "app/javascript/packs/hello_typescript.ts"
  insert_into_file "config/webpack/environment.js", <<~JS, before: "module.exports = environment"
    // so that modules in app/javascript don't shadow the ones in node_modules
    environment.resolvedModules.delete('source')
  JS

  # configure typescript and set up tslint
  remove_file "tsconfig.json"
  copy_file "tsconfig.json"
  copy_file "tslint.json"
  run "yarn add typescript tslint typescript-tslint-plugin tslint-react"

  # install remaining JS dependencies
  run "yarn add @shopify/polaris redux react-redux @types/react-redux"

  # webpack-dev-server should use https
  gsub_file "config/webpacker.yml", "https: false", "https: true"

  # create db and run migrations. Drop it first if it already exists (this usually happens when developing the template itself)
  rails_command "db:drop db:create db:migrate"

  say "Enter you app name and port for puma-dev."

  puma_dev_app = ask("app name for puma-dev:", default: app_name.gsub(/_/, ''))

  app_host = "#{puma_dev_app}.test"
  app_url = "https://#{app_host}"

  # required in Rails 6: whitelist the puma-dev host so it isn't blocked
  application "config.hosts = ['#{app_host}']", env: 'development'

  port = ask("PORT for puma-dev (e.g. 3005):") until port.present?

  say <<~MESSAGE

    Create a new shopify app with the following config
    - App URL: #{app_url}
    - Whitelisted Redirection URL: #{app_url}/auth/shopify/callback

    then give me your API Key and Secret Key.
  MESSAGE

  api_key = ask "API Key:" until api_key.present?
  secret_key = ask "Secret Key:" until secret_key.present?

  # set up puma-dev app
  run "echo #{port} > ~/.puma-dev/#{puma_dev_app}"

  file '.env', <<~CONTENTS
    SHOPIFY_API_KEY=#{api_key}
    SHOPIFY_SECRET_KEY=#{secret_key}
    PORT=#{port}
  CONTENTS

  # ignore .env
  append_to_file '.gitignore', ".env\n"

  # use environment variables for shopify config
  gsub_file 'config/initializers/shopify_app.rb', '"<api_key>"', 'ENV.fetch("SHOPIFY_API_KEY")'
  gsub_file 'config/initializers/shopify_app.rb', '"<secret>"', 'ENV.fetch("SHOPIFY_SECRET_KEY")'

  git add: "."
  git commit: '-a -m "generate everything else"'

  git add: "."
  git commit: '-a -m "run migrations"'

  puts <<~MESSAGE

    Congrats, you have created a new Shopify app. To run your app:

    cd #{app_name}
    heroku local -f Procfile.dev

    then go to #{app_url} in your browser.
  MESSAGE
end
