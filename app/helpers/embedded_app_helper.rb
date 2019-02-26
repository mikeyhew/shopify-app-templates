module EmbeddedAppHelper
  def polaris_version
    @polaris_version ||= JSON.parse(File.read('node_modules/@shopify/polaris/package.json'))["version"]
  end
end
