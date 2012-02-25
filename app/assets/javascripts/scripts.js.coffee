I18n =
  en:
    tweet_text: 'Hey @resto_net, please make %{city} your next city. #restonext'
    tweet_related: 'opennorth'
  fr:
    tweet_text: 'Hé @resto_net, svp ajouter la ville de %{city}. #restonext'
    tweet_related: 'nordouvert'

t = (string, args = {}) ->
  current_locale = args.locale or locale
  string = I18n[current_locale][string] or string
  string = string.replace ///%\{#{key}\}///g, value for key, value of args
  string

$ ->
  $('#twitter').submit (e) ->
    city = $('#twitter input').val()
    if city isnt '' and city isnt 'my city'
      window.open("http://twitter.com/share?url=#{encodeURIComponent 'http://resto-net.ca/'}&text=#{encodeURIComponent t('tweet_text', city: city)}&related=resto_net,#{t 'tweet_related'}&lang=#{locale}", 'intent', 'width=550,height=450');
    e.preventDefault()
