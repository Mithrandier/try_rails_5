class EditionsOrderer
  ORDERS = [
    BY_TITLE = :title,
    BY_AUTHOR = :author,
    OLD_FIRST = :old_first,
    NEW_FIRST = :new_first,
    LAST_UPDATED = :last_updated
  ]
  ORDER_SCOPES = {
    BY_TITLE => 'by_book_titles',
    BY_AUTHOR => 'by_author',
    OLD_FIRST => 'old_first',
    NEW_FIRST => 'new_first',
    LAST_UPDATED => 'by_updated_at'
  }.freeze

  def self.apply_to(editions_scope, order)
    editions_scope.send(ORDER_SCOPES.fetch(order.to_sym))
  end
end