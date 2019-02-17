# Usage

New Polaris App

```
rails new -d postgresql --skip-turbolinks --skip-javascript --skip-action-cable -m shopify-app-templates/polaris-rails.rb <app_name>
```

You need a few things for this to work properly:

- puma-dev needs to be installed and you need to get your system to trust its certificate. See the [puma-dev section](#puma-dev) for details.
- `gem install rails --pre` (until Rails 6.0 is officially released)
- make sure your Ruby version is up to date. This template is developed on the most recent version, currently 2.6.1, but some older versions may still work

# Handy tips

## puma-dev

- install with `brew install puma-dev`
- run `sudo puma-dev setup` so it can resolve domains for you
- run `puma-dev -install`
- You need to trust puma-dev's certificate. It is located at `~/Library/Application\ Support/io.puma.dev/cert.pem`. Double-click on that file to open it in Keychain Access. Right-click on the certificate from inside Keychain Access, click "Get Info", uncollapse the "Trust" section, then change the setting for "Secure Sockets Layer (SSL)" to "Always Trust". Close the "Get Info" window, and you will be prompted to enter your administrator password. Once you do that, it should be trusted, at least in Chrome.
- To trust it in Firefox, go to `about:config` and change the setting `security.enterprise_roots.enabled` to `true`. This will make Firefox trust your system certificates.
- the template script will create a puma-dev app for you, but it's easy to do manually. For example, if your app is at `https://myapp.test` and your rails server is listening on port 3322, run `echo 3322 >~/.puma-dev/myapp`.
- if you're having trouble with a puma-dev app, you can see the logs with `tail -f ~/Library/Logs/puma-dev.log`
- if you change the proxy port of a puma-dev app, it won't realize it until the process restarts. `pkill puma-dev` should work

## react-devtools

There is a branch of react-devtools that works over https/wss.

```bash
git clone --origin=textioHQ --branch=feature/secure-websockets --single-branch https://github.com/textioHQ/react-devtools
cd react-devtools
yarn
REACT_DEVTOOLS_HOST=react-devtools.test REACT_DEVTOOLS_WS_PORT=443 REACT_DEVTOOLS_WS_PROTOCOL=wss yarn test:standalone
```

For this to work, you also need to set up a puma-dev app:

```bash
echo 8097 >~/.puma-dev/react-devtools
```

The template optionally includes a script tag that loads `https://react-devtools.test`, but only if `Rails.env.development?`, and you have to add `?devtools=1` to the url in the address bar.

# Developing this template

I develop in VS Code because it has an awesome Typescript integration. Make sure you have the TSLint plugin from microsoft, and run `yarn` so that typescript can see your dependencies. You also need to run `npm install -g tslint` for VS Code to be able to lint your files with TSLint.
