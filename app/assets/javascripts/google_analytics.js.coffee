document.addEventListener 'turbo:load', (event) ->
  if typeof ga is 'function'
    ga('set', 'location', window.location.href)
    ga('send', 'pageview')