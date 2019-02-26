import * as React from "react";

import {UnstyledLinkProps, withAppProvider, WithAppProviderProps} from "@shopify/polaris";
import {BrowserRouter, Link, Route, Switch} from "react-router-dom";
import {LocationPropagator} from "shopify-js-deps";

import {Home} from "./Home";
import {NotFound} from "./NotFound";

export const Router: React.ComponentType = () => (
  <BrowserRouter>
    <>
      <LocationPropagator />
      <Switch>
        <Route exact path="/" component={Home} />
        <Route component={NotFound} />
      </Switch>
    </>
  </BrowserRouter>
);

export const LinkForPolaris = ({url, external, children, ...props}: UnstyledLinkProps) => {
  const target = external ? "_blank" : undefined;
  const rel = external ? "noopener noreferrer" : undefined;

  // pass on any extra props to the `a` element
  const allProps: { [key: string]: any} = props;

  return <Link to={url} target={target} rel={rel} children={children} {...allProps} />;
};
