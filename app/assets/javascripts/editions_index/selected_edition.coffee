Vue.component 'selected-edition',
  template: '#selected_edition_template'

  computed: Vuex.mapState
    edition: 'selectedEdition'
    openedEdition: 'openedEdition'
    editionIsOpened: ->
      @openedEdition && (@edition.id == @openedEdition.id)
    routes: -> Routes

  mounted: ->
    EventsDispatcher.$on 'selectEdition', (edition) =>
      @$store.commit('setSelectedEdition', edition)
      @openEdition()

  methods:
    editEdition: ->
      EventsDispatcher.$emit('editEdition', @edition)

    openEdition: ->
      EventsDispatcher.$emit('showEditionDetails', @edition)

    closeEdition: ->
      EventsDispatcher.$emit('hideEditionDetails')

    changeReadStatus: (edition) ->
      $.ajax(
        type: 'PUT'
        url: Routes.edition_path(edition.id)
        dataType: 'json'
        data: { edition: { read: !edition.read } }
        success: (updated_edition) =>
          edition.read = updated_edition.read
        error: @handleErrorResponse
      )

    removeEdition: (edition) ->
      $.ajax(
        type: 'DELETE'
        url: Routes.edition_path(edition.id)
        dataType: 'json'
        success: =>
          @editions.splice(@editions.indexOf(edition), 1)
        error: @handleErrorResponse
      )

    handleErrorResponse: (response) ->
      console.log('OOPS')
      console.log(response)