ImgItemPoint = Vue.extend
  template: document.querySelector '.js-imgItemPointTmpl'

  props: [ 'index', 'pointData' ]

  data: -> return {
    inputId: parseInt(@pointData.id)
    zIndex: 0
    isFocused: false
  }

  computed:
    styleObj: -> return {
      top: "#{@pointData.y * @scale}px"
      left: "#{@pointData.x * @scale}px"
      opacity: "#{@$store.state.pointOpacity}"
      'z-index': @zIndex
    }
    showId: -> return @$store.state.showId
    pointColor: -> return @$store.state.pointColor
    scale: -> return @$store.state.scale


  methods:
    getData: ->
      return {
        id: parseInt(@pointData.id)
        x: @pointData.x
        y: @pointData.y
      }

    onChangeId: ->
      log("changeId")
      @$emit 'changeId', {
        uid: @pointData.uid
        id: parseInt(@inputId)
      }
      return

    onFocusId: (e)->
      @isFocused = true
      input = e.target
      input.select 0, input.value.length
      @zIndex = 2
      return

    onBlurId: (e)->
      @isFocused = false
      @zIndex = 0
      return

    onMouseDown: (e)->
      @zIndex = 2

      mouseMoveHandler = (e)=>
        @$emit 'drag', {
          pageX: e.pageX
          pageY: e.pageY
          id: parseInt(@pointData.id)
          uid: @pointData.uid
        }
        e.stopImmediatePropagation()
        e.preventDefault()

      mouseUpHandler = (e)=>
        @zIndex = 0
        window.removeEventListener 'mousemove', mouseMoveHandler
        window.removeEventListener 'mouseup', mouseUpHandler
        e.stopImmediatePropagation()
        e.preventDefault()

      window.addEventListener 'mousemove', mouseMoveHandler
      window.addEventListener 'mouseup', mouseUpHandler
      return

    remove: ->
      @$emit 'removed', @pointData.uid
      return

    update: ->
      @inputId = parseInt(@pointData.id)
      return


export default ImgItemPoint
