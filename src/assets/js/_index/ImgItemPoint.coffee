ImgItemPoint = Vue.extend
  template: document.querySelector '.js-imgItemPointTmpl'
  props: [ 'index', 'pointData' ]
  computed:
    styleObj: -> return {
      top: "#{@pointData.y}px"
      left: "#{@pointData.x}px"
    }
  data: -> return {
    inputId: ''
  }
  mounted: ->
    @inputId = @pointData.id
    return

  updated: ->
    # @inputId = @pointData.id
    return


  methods:
    getData: ->
      return {
        id: @pointData.id
        x: @pointData.x
        y: @pointData.y
      }

    onChangeId: ->
      # @pointData.id = @inputId
      log @inputId
      @$emit 'changeId', { uid: @pointData.uid, id: @inputId }

    onMouseDown: (e)->

      mouseMoveHandler = (e)=>
        @$emit 'drag', {
          x: e.pageX - @pointData.offsetX
          y: e.pageY - @pointData.offsetY
          id: @pointData.id
          uid: @pointData.uid
        }
        e.stopImmediatePropagation()
        e.preventDefault()

      mouseUpHandler = (e)=>
        window.removeEventListener 'mousemove', mouseMoveHandler
        window.removeEventListener 'mouseup', mouseUpHandler
        e.stopImmediatePropagation()
        e.preventDefault()

      window.addEventListener 'mousemove', mouseMoveHandler
      window.addEventListener 'mouseup', mouseUpHandler


    remove: ->
      @$emit 'removed', @pointData.uid
      return

export default ImgItemPoint
