Vue.component 'edition-details',
  template: '#edition_details_template'

  data: ->
    enabled: false
    edition: null

  mounted: ->
    EventsDispatcher.$on 'showEditionDetails', (edition) =>
      DataRefresher.loadEditionDetails(edition).then (detailedEdition) =>
        @edition = detailedEdition
        @show()

  computed: Vuex.mapState
    editions: 'editions'
    canBeShown: ->
      @edition && @enabled

    coverStyle: ->
      'background-image: url(' + @coverUrl + ')'

    coverUrl: ->
      @edition.cover_url

    currentEditionIndex: ->
      @editions.findIndex((e) => e.id == @edition.id)

    rightPageNumber: ->
      @currentEditionIndex * 2

    leftPageNumber: ->
      @rightPageNumber + 1

    canSwitchToPrievousEdition: ->
      @currentEditionIndex > 0

    canSwitchToNextEdition: ->
      @currentEditionIndex < (@editions.length - 1)

    annotation: ->
      @edition.annotation && @edition.annotation.autoLink(target: '_blank')

    booksByAuthors: ->
      booksByAuthors = []
      for book in @edition.books
        continue if booksByAuthors.find((bba) => _.isEqual(bba.authors, book.authors))
        books = @edition.books.filter((b) => _.isEqual(b.authors, book.authors))
        booksByAuthors.push(
          authors: book.authors
          books: books
        )
      booksByAuthors

    bookTitles: ->
      return @edition.title if @edition.title
      _.reduce(
        _.map(@edition.books, 'title'),
        (t1, t2) => "#{t1}; #{t2}"
      )


  methods:
    show: ->
      @enabled = true

    close: ->
      @enabled = false

    switchToAuthor: (author) ->
      @$store.commit('setAuthor', author.name)
      @close()

    switchToPublisher: (publisher) ->
      @$store.commit('setPublisher', publisher.name)
      @close()

    switchToCategory: (category) ->
      @$store.commit('setCategory', category.code)
      @close()

    switchToNextEdition: ->
      return unless @canSwitchToNextEdition
      EventsDispatcher.$emit 'showEditionDetails', (@editions[@currentEditionIndex + 1])

    switchToPreviousEdition: ->
      return unless @canSwitchToPrievousEdition
      EventsDispatcher.$emit 'showEditionDetails', (@editions[@currentEditionIndex - 1])

    editEdition: ->
      @close()
      EventsDispatcher.$emit('editEdition', @edition)

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
