import * as React from "react";

import {Card, Layout, Link, Page} from "@shopify/polaris";

export const Home: React.ComponentType = () => (
  <Page title="Home">
    <Layout sectioned>
      <Card sectioned title="Welcome to my app!">
        <p>This is the home page. Edit it in app/javascript/Home.tsx</p>
        <p><Link url="/nowhere">Here</Link> is a link to a page that doesn't exist. Click on it to see the NotFound page.</p>
      </Card>
    </Layout>
  </Page>
);
