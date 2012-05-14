# coding: utf-8
$.fn.popover.Constructor.prototype.setContent = ->
    $tip = @tip()
    $tip.find('.popover-title').html @getTitle()
    $tip.find('.popover-content').html @getContent()
    $tip.removeClass 'fade top bottom left right in'

I18n =
  en:
    tweet_text: 'Hey @resto_net, please make %{city} your next city. cc @opennorth'
    tweet_related: 'opennorth'
    summary:
      one: 'Fined <b>once</b> for <b>%{total}</b> on %{date}'
      other: 'Fined <b>%{count} times</b> totaling <b>%{total}</b>, most recently %{amount} on %{date}'
  fr:
    tweet_text: 'Hé @resto_net, svp ajouter prochainement la ville de %{city}. cc @opennorth'
    tweet_related: 'nordouvert'
    summary:
      one: 'Condamné à <b>une amende</b> de <b>%{total}</b> le %{date}'
      other: 'Condamné à <b>%{count} amendes</b> totalisant <b>%{total}</b>, plus récemment %{amount} le %{date}'

# t is undefined in template unless it is global.
window.t = (string, args = {}) ->
  current_locale = args.locale or locale
  if 'count' of args
    if args.count == 1
      string = I18n[current_locale][string].one
    else
      string = I18n[current_locale][string].other
  else
    string = I18n[current_locale][string] or string
  string = string.replace ///%\{#{key}\}///g, value for key, value of args
  string

popupTemplate = _.template """
<h3><a href="<%= url %>"><%= name %></a></h3>
<p><%= t('summary', {count: count, total: total, amount: amount, date: date}) %></p>
"""

$ ->
  $('a[rel=popover]').popover
    template: '<div class="popover"><div class="arrow"></div><div class="popover-inner"><blockquote><p class="popover-content"></p><small class="popover-title"></small></blockquote></div></div>'

  $('#twitter').submit (event) ->
    city = $('#twitter input').val()
    if city isnt '' and city isnt 'my city'
      window.open("http://twitter.com/share?url=#{encodeURIComponent 'http://resto-net.ca/'}&text=#{encodeURIComponent t('tweet_text', city: city)}&related=resto_net,#{t 'tweet_related'}&lang=#{locale}", 'intent', 'width=550,height=450');
    event.preventDefault()

  if center? and zoom? and bounds?
    map = new L.Map 'map',
      center: center
      zoom: zoom
      layers: [
        new L.TileLayer 'http://{s}.tile.cloudmade.com/266d579a42a943a78166a0a732729463/51080/256/{z}/{x}/{y}.png',
          attribution: '© 2011 <a href="http://cloudmade.com/">CloudMade</a> – Map data <a href="http://creativecommons.org/licenses/by-sa/2.0/">CCBYSA</a> 2011 <a href="http://openstreetmap.org/">OpenStreetMap.org</a> – <a href="http://cloudmade.com/about/api-terms-and-conditions">Terms of Use</a>'
      ],
      minZoom: zoom
    map.attributionControl.setPrefix null

    map.on 'locationfound', (event) ->
      if bounds.contains event.latlng
        map.addLayer new L.Marker event.latlng, clickable: false
        map.setView event.latlng, 16
    map.locate()

    styles = _.map [36, 52, 67, 77, 87, 102, 112], (size, i) ->
      url: "/assets/clusters/#{i + 2}.png"
      width: size
      height: size
      opt_textColor: 'white'
    clusterer = new LeafClusterer map, null, styles: styles
    markers = _.map establishments, (establishment) ->
      icon = L.Icon.extend
        iconUrl: "/assets/icons/red#{establishment.icon}.png"
        iconSize: new L.Point 27, 27
        shadowUrl: null
      marker = new L.Marker new L.LatLng(establishment.lat, establishment.lng), icon: new icon
      clusterer.addMarker marker
      marker.bindPopup popupTemplate establishment

  if latlng?
    map = new L.Map 'mini-map',
      center: latlng
      zoom: 16
      layers: [
        new L.TileLayer 'http://{s}.tile.cloudmade.com/266d579a42a943a78166a0a732729463/51080/256/{z}/{x}/{y}.png',
          attribution: '© <a href="http://cloudmade.com/">CloudMade</a> – <a href="http://creativecommons.org/licenses/by-sa/2.0/">CCBYSA</a> <a href="http://openstreetmap.org/">OpenStreetMap.org</a> – <a href="http://cloudmade.com/about/api-terms-and-conditions">Terms</a>'
      ]
      minZoom: 10
      maxZoom: 18
    map.attributionControl.setPrefix null
    map.addLayer new L.Marker latlng, clickable: false
