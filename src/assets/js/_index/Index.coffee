import ImgItem from './ImgItem'

export default class Index
  constructor: ->
    @_initDatGUI()
    @_initVuexStore()
    @_initPlotTool()
    @_removeLoading()


  _initDatGUI: ->
    @scale = 1
    @pointColor = '#ff0000'
    @pointOpacity = 1
    @showId = true

    @_datGUI = new dat.GUI()

    f1 = @_datGUI.addFolder 'data'
    f1.add @, 'importJSON'
    f1.add @, 'exportJSON'
    f1.add @, 'resetAllPlotData'
    f1.add @, 'resetAllImgs'
    f1.open()

    f2 = @_datGUI.addFolder 'display'
    f2.open()

    f2.add(@, 'scale', 0.2, 10).step(0.1)
    .onChange (value)=>
      @_store.commit 'setScale', value
      return

    f2.add(@, 'pointOpacity', 0.1, 1).step 0.1
    .onChange (value)=>
      @_store.commit 'setPointOpacity', value
      return

    f2.addColor @, 'pointColor'
    .onChange (value)=>
      @_store.commit 'setPointColor', value
      return

    f2.add @, 'showId'
    .onChange (value)=>
      @_store.commit 'setShowId', value
      return


  importJSON: ->
    @_plotTool.openImporter()

  exportJSON: ->
    @_plotTool.exportData()

  resetAllPlotData: ->
    @_plotTool.resetAllPlotData()

  resetAllImgs: ->
    @_plotTool.resetAllImgs()


  _initVuexStore: ->
    Vue.use Vuex
    @_store = new Vuex.Store
      state:
        scale: 1
        pointColor: '#ff0000'
        pointOpacity: 1
        showId: true

      mutations:
        setScale: (state, scale)=>
          state.scale = scale
          @scale = scale

        setPointColor: (state, pointColor)=>
          state.pointColor = pointColor
          @pointColor = pointColor

        setPointOpacity: (state, pointOpacity)=>
          state.pointOpacity = pointOpacity
          @pointOpacity = pointOpacity

        setShowId: (state, showId)=>
          state.showId = showId
          @showId = showId



  _initPlotTool: ->
    @_plotTool = new Vue
      el: '.js-plotTool'

      components:
        imgitem: ImgItem

      store: @_store

      data:
        isImporterOpened: false
        pointsData: []
        imgsData: []

      computed:
        jsonFileName: -> "points.json"
        hasImgs: -> @imgsData?.length isnt 0

      methods:
        resetAllImgs: ->
          @pointsData = []
          @imgsData = []
          return

        resetAllPlotData: ->
          for child, i in @$children
            child.reset()
          @pointsData = []
          return

        imgsOnDragOver: (e)->
        imgsOnDrop: (e)->
          files = e.dataTransfer.files

          for file in files
            if !file? or (file.type isnt 'image/jpeg' and file.type isnt 'image/png' and file.type isnt 'image/gif')
              alert 'Error. Please drag and drop JPEG/PNG/GIF file.'
              return

          for file in files
            @imgsData.push URL.createObjectURL(file)

          return

        importerOnDragOver: (e)->
        importOnDrop: (e)->
          @resetAllPlotData()

          file = e.dataTransfer.files[0]
          if !file? or file.type isnt 'application/json'
            alert 'Error. Please drag and drop JSON file.'
            @isImporterOpened = false
            return

          reader = new FileReader()
          reader.onload = (e)=>
            data = JSON.parse e.target.result
            @isImporterOpened = false
            log(data);

            @pointsData = []
            for child, i in @$children
              child.importData? data[i]
          reader.readAsText file

          e.stopImmediatePropagation()
          return


        getData: ->
          @pointsData = []
          for child in @$children
            if child.getData?
              @pointsData.push child.getData()
          @currentFramePointsData = @pointsData[@currentFrameIndex]
          return @pointsData


        exportData: ->
          if @imgsData.length is 0
            alert 'no image.'
            return

          @getData()

          log @pointsData
          if @pointsData.length is 0
            alert 'no plot data.'
            return

          blob = new Blob [ JSON.stringify(@pointsData, null, '  ')], { type: 'application\/json' }
          downloadURL = URL.createObjectURL(blob);

          dummy = document.createElement 'a'
          dummy.href = downloadURL
          dummy.download = @jsonFileName
          dummy.click()
          URL.revokeObjectURL downloadURL
          return


        closeImporter: ->
          @isImporterOpened = false
          return

        openImporter: ->
          if @imgsData.length is 0
            alert 'no image.'
            return
          @isImporterOpened = true

          onKeyDown = (e)=>
            if e.keyCode is 27  # esc key
              @isImporterOpened = false
              document.removeEventListener 'keydown', onKeyDown
            e.preventDefault()
            return

          document.addEventListener 'keydown', onKeyDown



  _removeLoading: ->
    loading = document.querySelector('.js-loading')

    transitionEndHandler = (e)->
      loading.removeEventListener 'transitionend', transitionEndHandler
      loading.parentNode.removeChild loading
      return

    loading.addEventListener 'transitionend', transitionEndHandler
    loading.classList.add 'is-loaded'
