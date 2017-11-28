import React from 'react'
import {Layout, Card} from '@shopify/polaris'
import {EmbeddedApp} from '@shopify/polaris/embedded'
import Page from './Page'
import {BrowserRouter, Route} from 'react-router-dom'

const {apiKey, shopOrigin, debug} = appConfig

const Home = () => (
  <Page title='Home'>
    <Layout>
      <Layout.Section>
        <Card title='My App' sectioned>Welcome to my app!</Card>
      </Layout.Section>
    </Layout>
  </Page>
)

const NotFound = () => (
  <Page>
      <Layout>
          <Layout.Section>
              <Card title='Not Found' sectioned>
                Oops, looks like that page doesn't exist. <Link to="/">Go Home</Link>
              </Card>
          </Layout.Section>
      </Layout>
  </Page>
)

const App = () => (
  <EmbeddedApp
    apiKey={apiKey}
    shopOrigin={shopOrigin}
    forceRedirect={true}
    debug={debug}
  >
    <BrowserRouter>
      <Switch>
        <Route exact path="/" component={Home} />
        <Route component={NotFound} />
      </Switch>
    </BrowserRouter>
  </EmbeddedApp>
)

export {App}
