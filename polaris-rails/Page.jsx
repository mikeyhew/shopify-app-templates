import {Page as PolarisPage} from '@shopify/polaris'

const FILTER_REGEX = /(^|&)(timestamp|protocol|hmac|shop|locale)=[^&]*/g

const filteredQuery = () => {
  const filtered = window.location.search.slice(1).replace(FILTER_REGEX, '')
  if (filtered.length > 0) {
    return '?' + filtered
  } else {
    return ''
  }
}

const getLocation = () => (
  window.location.pathname.replace(/^\/embedded/, '') + filteredQuery()
)

export default class Page extends PolarisPage {
  handleEASDKMessaging(...args) {
    const ret = super.handleEASDKMessaging(...args)
    const location = getLocation()
    this.context.easdk.messenger.send('Shopify.API.replaceState', {location})
    ret
  }
}
