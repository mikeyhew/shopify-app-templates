Sequel.migration do
  change do
    create_table :shops do
      primary_key :id
      String :shopify_domain, null: false, unique: true
      String :shopify_token
    end
  end
end
