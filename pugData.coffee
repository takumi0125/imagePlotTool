config =
  default:
    siteUrl: 'https://plottool.unshift.jp/'
    keywords: 'image, tool, plot'

    showOGP: true # ogpタグを表示するかどうか

    siteTitle: 'image plot tool'
    useTitleAsOgTitle: true # ogTitleをtitleと同じにするかどうか
    ogTitle: ''
    useTitleSeparater: true
    titleSeparater: ' | '

    description: "image plot tool on the web."
    useDescriptionAsOgDescription: true # ogDescriptionをdescriptionと同じにするかどうか
    ogDescription: ""

    ogSiteName: 'image plot tool'

    ogImage: 'https://plottool.unshift.jp/assets/img/ogp.png'
    ogImageType: 'image/png'
    ogImageWidth: '1200'
    ogImageHeight: '630'

    ogType: 'website'

    showTwitterCard: true # twitterCardを表示するかどうか
    twitterCardType: 'summary_large_image'
    useOgAsTwitterCard: true # twitterCardの各値をogの各値と同じにするかどうか
    twitterCardTitle: ''
    twitterCardDesc: ''
    twitterCardImg: ''

    favicons:
      default: '/assets/img/icon/favicon.ico'
      "96x96": '/assets/img/icon/favicon-96.png'
      "192x192": '/assets/img/icon/favicon-192.png'

    appleTouchIcons:
      # default: '/assets/img/icon/apple-touch-icon.png'
      "57x57"  : '/assets/img/icon/apple-touch-icon-57.png'
      "60x60"  : '/assets/img/icon/apple-touch-icon-60.png'
      "72x72"  : '/assets/img/icon/apple-touch-icon-72.png'
      "76x76"  : '/assets/img/icon/apple-touch-icon-76.png'
      "114x114": '/assets/img/icon/apple-touch-icon-114.png'
      "120x120": '/assets/img/icon/apple-touch-icon-120.png'
      "144x144": '/assets/img/icon/apple-touch-icon-144.png'
      "152x152": '/assets/img/icon/apple-touch-icon-152.png'
      "180x180": '/assets/img/icon/apple-touch-icon-180.png'

    manifestJson: '/assets/img/icon/manifest.json'

  develop:
    siteUrl: 'https://plottool.unshift.jp/'
    ogImage: 'https://plottool.unshift.jp/assets/img/ogp.png'

  staging:
    siteUrl: 'https://plottool.unshift.jp/'
    ogImage: 'https://plottool.unshift.jp/assets/img/ogp.png'

  production:
    siteUrl: 'https://plottool.unshift.jp/'
    ogImage: 'https://plottool.unshift.jp/assets/img/ogp.png'


module.exports = (env) ->
  data = config.default
  for key, value of config[env]
    data[key] = value
  return data
