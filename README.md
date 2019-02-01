# Usage

New Polaris App

```
rails new -d postgresql --skip-turbolinks --skip-javascript --skip-action-cable -m shopify-app-templates/polaris-rails.rb <app_name>
```

You need a few things for this to work properly:

- puma-dev needs to be installed (`brew install puma-dev`). It will create files in ~/.puma-dev for each of your apps, so that it will proxy requests, e.g. from https://appname.test to http://localhost:3322 or whatever port number you supply.
- You need to trust puma-dev's certificate. It is located at ~/Library/Application Support/io.puma.dev/cert.pem
- Right now this works with Rails 5.2 and Ruby 2.5.3. It probably works with Rails 6.0.0.beta1 and Ruby 2.6.0, but I have yet to test that out

# Developing

If you are editing typescript files, use VS Code with the Typescript TSLint Plugin installed, and run `yarn` so that typescript can see your dependencies. You also need to run `npm install -g tslint` for VS Code to be able to lint your files with TSLint.
