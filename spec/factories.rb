FactoryGirl.define do
  factory :author do
    name { FFaker::Book.author }
  end

  factory :book do
    title { FFaker::Book.title }
    authors { build_list(:author, 1) }
  end

  factory :edition do
    books { build_list(:book, 1) }
    category { build(:edition_category) }

    title { FFaker::Book.title }
    isbn { FFaker::Book.isbn }
    cover_url { FFaker::Book.cover }
    annotation { FFaker::Book.description }
  end

  factory :edition_category do
    sequence(:code) { |n| "EditionCategory #{n}" }
  end

  factory :book_in_edition do
    book
    edition
  end

  factory :publisher do
    sequence(:name) { |n| "Publisher #{n}" }
  end
end
