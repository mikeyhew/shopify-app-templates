import * as React from "react";

import {AppProvider} from "@shopify/polaris";

import {LinkForPolaris, Router} from "./Router";

declare const SHOPIFY_API_KEY: string;
declare const SHOP_ORIGIN: string;

export const App: React.ComponentType = () => (
  <AppProvider
    apiKey={SHOPIFY_API_KEY}
    shopOrigin={SHOP_ORIGIN}
    linkComponent={LinkForPolaris}
  >
    <Router />
  </AppProvider>
);
