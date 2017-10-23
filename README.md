# Usage

New Polaris app

```
rails new -d postgresql -m shopify-app-templates/polaris-rails.rb <app_name>
```

New Polaris app with Sequel instead of ActiveRecord

```
rails new --skip-active-record -m shopify-app-templates/polaris-rails-sequel.rb <app_name>
```

New Sequel app (without Polaris)

```
rails new --skip-active-record -m shopify-app-templates/sequel-shopify-app.rb <app_name>
```

# Developing

`polaris-rails.rb` and `polaris-rails-sequel.rb` should be kept in sync. When you make a change to one, you should make the same change to the other if it applies. Run the following diff command and make sure the differences are minimal:

```
diff polaris-rails.rb polaris-rails-sequel
```

`sequel-shopify-app` is pretty much obsolete now, so don't bother updating it when you update the others.
