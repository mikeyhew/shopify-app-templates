import * as React from "react";

import {AppProvider, Page} from "@shopify/polaris";
import {Provider as ReduxProvider} from "react-redux";
import {createStore} from "redux";

import {reducer} from "./redux";

declare const SHOPIFY_API_KEY: string;
declare const SHOP_ORIGIN: string;

const reduxStore = createStore(reducer);

export const App = (): JSX.Element => (
  <ReduxProvider store={reduxStore}>
    <AppProvider apiKey={SHOPIFY_API_KEY} shopOrigin={SHOP_ORIGIN}>
      <Page title = "Hello!">
        <p>Hello from React and Polaris!</p>
      </Page>
    </AppProvider>
  </ReduxProvider>
);
