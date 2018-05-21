import pad from '../_utils/string/pad'
import ImgItem from './ImgItem'

export default class Index
  constructor: ->
    @_plotTool = new Vue
      el: '.js-plotTool'

      data:
        isImporterOpened: false
        pointsData: []
        imgsData: []

      mounted: ->

      updated: ->

      computed:
        jsonFileName: -> "points.json"
        hasImgs: -> @imgsData?.length isnt 0

      components:
        imgitem: ImgItem

      methods:
        reset: ->
          @pointsData = []
          @imgsData = []

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
          @getData()

          log @pointsData
          blob = new Blob [ JSON.stringify(@pointsData, null, '  ')], { type: 'application\/json' }
          downloadURL = URL.createObjectURL(blob);

          dummy = document.createElement 'a'
          dummy.href = downloadURL
          dummy.download = @jsonFileName
          dummy.click()
          URL.revokeObjectURL downloadURL
          return

        openImporter: ->
          @isImporterOpened = true
