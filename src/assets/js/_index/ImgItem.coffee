import pad from '../_utils/string/pad'
import preloadImg from '../_utils/img/preloadImg'
import ImgItemPoint from './ImgItemPoint'

ImgItem = Vue.extend
  template: document.querySelector '.js-imgItemTmpl'

  components:
    imgitempoint: ImgItemPoint

  props: [ 'index', 'imgData' ]

  data: -> return {
    pointsData: []
    imgURL: ''
    numPoints: 0
    numAllPointsCnt: 0
    width: 0
    height: 0
  }

  computed:
    imgStyleObj: -> return {
      'background-image': "url(#{@imgURL})"
      width: "#{@width * @scale}px"
      height: "#{@height * @scale}px"
    }
    scale: -> return @$store.state.scale

  mounted: ->
    @imgURL = @imgData
    @inner = @$el.querySelector '.js-inner'
    preloadImg(@imgURL).then (img)=>
      @width = img.width
      @height = img.height


  methods:
    getData: ->
      data = []
      for child in @$children
        data.push child.getData()
      data = _.sortBy data, (d)-> d.id
      return data

    onIdChanged: (data)->
      index = _.findIndex @pointsData, (d)-> d.uid is data.uid
      @pointsData[index].id = data.id
      return

    onRemoved: (uid)-> @remove uid

    onDrag: (data)->
      index = _.findIndex @pointsData, (d)-> d.uid is data.uid
      pointData = @pointsData[index]
      pointData.x = (data.pageX - @inner.offsetLeft - @$el.offsetLeft) / @scale
      pointData.y = (data.pageY - @inner.offsetTop - @$el.offsetTop) / @scale
      return

    importData: (data)->
      @numPoints = data.length
      @numAllPointsCnt = data.length
      for d, i in data
        @pointsData.push {
          id: d.id
          x: d.x
          y: d.y
          uid: i
        }
      return

    addPoint: (e = null)->
      if e
        x = (e.pageX - @inner.offsetLeft - @$el.offsetLeft) / @scale
        y = (e.pageY - @inner.offsetTop - @$el.offsetTop) / @scale
      else
        x = @width / 2
        y = @height / 2

      id = Math.max(@numPoints, (_.max(@pointsData, ((d)-> d.id)).id + 1) || 0);
      @pointsData.push {
        id: id
        x: x
        y: y
        uid: @numAllPointsCnt
      }
      @numAllPointsCnt++
      @numPoints++
      return

    remove: (uid)->
      @pointsData = _.reject @pointsData, (data)-> data.uid is uid
      @numPoints--
      for child in @$children
        child.$forceUpdate()

      return

    reset: ->
      @numPoints = 0
      @numAllPointsCnt = 0
      @pointsData = []
      return

export default ImgItem
