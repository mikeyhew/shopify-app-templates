import * as React from "react";

import {EmptyState, Page} from "@shopify/polaris";

export const NotFound = () => {
  const action = {
    content: "Go to App Homepage",
    url: "/",
  };

  return (
    <Page title="Page Not Found">
      <EmptyState
        heading="Oops! Looks like that page doesn't exist."
        action={action}
        image=""
      >
        <p>We couldn't find any page at "{window.location.pathname}"</p>
      </EmptyState>
    </Page>
  );
};
