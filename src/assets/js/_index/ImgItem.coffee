import pad from '../_utils/string/pad'
import preloadImg from '../_utils/img/preloadImg'
import ImgItemPoint from './ImgItemPoint'

ImgItem = Vue.extend
  template: document.querySelector '.js-imgItemTmpl'
  data: -> return {
    pointsData: []
    imgURL: ''
    numPoints: 0
    numAllPoints: 0
    width: 0
    height: 0
  }
  mounted: ->
    @imgURL = @imgData
    preloadImg(@imgURL).then (img)=>
      @width = img.width
      @height = img.height


  computed:
    styleObj: ->
      return {
        width: "#{@width}px"
        height: "#{@height}px"
        'background-image': "url(#{@imgURL})"
      }

  props: [ 'index', 'imgData' ]
  components:
    imgitempoint: ImgItemPoint

  methods:
    getData: ->
      data = []
      for child in @$children
        data.push child.getData()
      return data

    onIdChanged: (data)->
      index = _.findIndex @pointsData, (d)-> d.uid is data.uid
      @pointsData[index].id = data.id
      @$emit 'updated'
      return

    onRemoved: (uid)->
      @remove uid
      @$emit 'updated'
      return

    onDrag: (data)->
      index = _.findIndex @pointsData, (d)-> d.uid is data.uid
      pointData = @pointsData[index]
      pointData.x = data.x
      pointData.y = data.y
      pointData.offsetX = @$el.offsetLeft
      pointData.offsetY = @$el.offsetTop
      @$emit 'updated'
      return

    importData: (data)->
      @numPoints = data.length
      @numAllPoints = data.length
      for d, i in data
        @pointsData.push {
          id: d.id
          x: d.x
          y: d.y
          uid: i
          offestX: @$el.offsetLeft
          offsetY: @$el.offsetTop
        }
      return

    addPoint: (e = null)->
      @numAllPoints++
      @numPoints++

      x = @width / 2
      y = @height / 2

      id = @numPoints - 1;
      @pointsData.push {
        id: id
        x: x
        y: y
        uid: @numAllPoints
        offestX: @$el.offsetLeft
        offsetY: @$el.offsetTop
      }
      @$emit 'point'
      return

    remove: (uid)->
      @pointsData = _.reject @pointsData, (data)-> data.uid is uid
      @numPoints--
      return

export default ImgItem
