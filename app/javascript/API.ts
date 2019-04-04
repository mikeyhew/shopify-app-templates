import * as t from "io-ts";
import {request} from "shopify-js-deps/lib/typed-rest-api";

export const API = {
  getAppInfo: () => request({
    method: "GET",
    url: "/api/app_info",
    responseType: t.type({
      app: t.type({
        handle: t.string,
      }),
    }),
  }),
};
