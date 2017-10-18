import React from 'react'
import {Page, Layout, Card} from '@shopify/polaris'
import {EmbeddedApp} from '@shopify/polaris/embedded'
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

const App = () => (
  <EmbeddedApp
    apiKey={apiKey}
    shopOrigin={shopOrigin}
    forceRedirect={true}
    debug={debug}
  >
    <BrowserRouter>
      <Route path="/" component={Home} />
    </BrowserRouter>
  </EmbeddedApp>
)

export {App}
