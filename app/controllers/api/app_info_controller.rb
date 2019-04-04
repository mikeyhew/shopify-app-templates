class Api::AppInfoController < ShopifyApp::AuthenticatedController
  def show
    result = ShopifyGraphQLClient.query(QUERY)

    render json: {
      app: {
        handle: result.data.app.handle
      }
    }
  end

  QUERY = ShopifyGraphQLClient.parse <<~GRAPHQL
    {
      app {
        handle
      }
    }
  GRAPHQL
end
