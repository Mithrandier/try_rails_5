Vue.component 'selection-meta-info',
  template: '#selection_meta_info_template'

  data: ->
    editAuthorMode: false
    authorFormName: ''
    editPublisherMode: false
    publisherFormName: ''

  computed: Vuex.mapState
    editions: 'editions'

    editionsCount: ->
      @$store.getters.filteredEditions.length

  methods:
    addNewEdition: ->
      EventsDispatcher.$emit('addNewEdition')
