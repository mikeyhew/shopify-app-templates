oldPushState = history.pushState
oldReplaceState = history.replaceState

FILTER_REGEX = /(^|&)(timestamp|protocol|hmac|shop)=[^&]*/g

filteredQuery = ->
  if window.location.search.length > 0
    '?' + window.location.search.slice(1).replace FILTER_REGEX, ''
  else ''

history.pushState = ->
  retval = oldPushState.apply(this, arguments)
  ShopifyApp.replaceState window.location.pathname + filteredQuery()
  retval

history.replaceState = ->
  retval = oldReplaceState.apply(this, arguments)
  ShopifyApp.replaceState window.location.pathname + filteredQuery()
  retval

window.addEventListener 'popstate', ->
  ShopifyApp.replaceState window.location.pathname + filteredQuery()
