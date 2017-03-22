Vue.component 'editions-index',
  props:
    initialOrder: { required: true }
    initialCategory: {}

  mounted: ->
    @currentOrder = @initialOrder
    @currentCategory = @initialCategory || null
    @reloadEditions()
    @$watch 'currentOrder', @reloadEditions
    @$watch 'currentAuthor', @reloadEditions
    @$watch 'currentPublisher', @reloadEditions

  data: => {
    editions: []
    currentAuthor: null
    currentPublisher: null
    currentOrder: null
    currentCategory: null
  }

  computed:
    filteredEditions: ->
      return @editions if !@currentCategory
      @editionsOfCategory(@currentCategory)

  methods:
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

    editionUrl: (edition) ->
      Routes.edition_path(edition.id)

    editEditionUrl: (edition) ->
      Routes.edit_edition_path(edition.id)

    authorUrl: (author) ->
      Routes.editions_path(author: author)

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

    switchToCategory: (categoryCode) ->
      @currentCategory = categoryCode

    currentCategoryIs: (categoryToCheck) ->
      @currentCategory == categoryToCheck

    editionsOfCategory: (categoryCode) ->
      @editions.filter((e) => e.category == categoryCode)

    anyEditionsOfCategory: (categoryToCheck) ->
      !!@editionsOfCategory(categoryToCheck).length

    switchToOrder: (orderCode) ->
      @currentOrder = orderCode

    currentOrderIs: (orderToCheck) ->
      @currentOrder == orderToCheck

    switchToAuthor: (author) ->
      @currentAuthor = author

    currentAuthorIs: (authorToCheck) ->
      @currentAuthor == authorToCheck

    switchToPublisher: (publisher) ->
      @currentPublisher = publisher

    currentPublisherIs: (publisherToCheck) ->
      @currentPublisher == publisherToCheck

    reloadEditions: ->
      $.getJSON(
        Routes.editions_path(
          order: @currentOrder
          author: @currentAuthor
          publisher: @currentPublisher
        ),
        (data) => @editions = data
      )
