import * as React from "react";

import {Card, Layout, Link, List, Loading, Page, TextContainer} from "@shopify/polaris";
import {API} from "./API";
import {usePromise} from "shopify-js-deps";

export const Home: React.ComponentType = () => {
  const [loadState] = usePromise(() => API.getAppInfo());

  let appInfo: JSX.Element;

  if (loadState.status === "loading") {
    appInfo = (
      <>
        <Loading />
        <p>Loading info about the app...</p>
      </>
    );
  } else if (loadState.status === "error") {
    appInfo = (
      <p>An error occurred while loading app info.</p>
    );
  } else {
    appInfo = (
      <List type="bullet">
        <List.Item>
          Your app handle is <tt>{loadState.data.app.handle}</tt>. To use it instead of the API key in the embedded app URL, add <tt>SHOPIFY_APP_HANDLE={loadState.data.app.handle}</tt> to your .env file and reboot the server.
        </List.Item>
      </List>
    );
  }

  return (
    <Page title="Home">
      <Layout sectioned>
        <Card title="Welcome to my app!">
          <Card.Section>
            <p>This is the home page. Edit it in app/javascript/Home.tsx</p>
            <p><Link url="/nowhere">Here</Link> is a link to a page that doesn't exist. Click on it to see the NotFound page.</p>
          </Card.Section>
          <Card.Section>
            {appInfo}
          </Card.Section>
        </Card>
      </Layout>
    </Page>
  );
};
