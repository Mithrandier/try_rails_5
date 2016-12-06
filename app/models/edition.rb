# == Schema Information
#
# Table name: editions
#
#  id            :integer          not null, primary key
#  isbn          :string           not null
#  title         :string
#  annotation    :text
#  cover_url     :string
#  editor        :string
#  pages_count   :integer
#  language_code :string
#

class Edition < ApplicationRecord
  has_many :book_in_editions
  has_many :books, through: :book_in_editions

  accepts_nested_attributes_for :books

  validates_presence_of :isbn, :books
end
