require 'shopify_app_mixins/sequel_session_storage'

class Shop < Sequel::Model
  include ShopifyAppMixins::SequelSessionStorage
end
