Factory.define :book do |book|
  book.name "Animal Farm"
  book.authors "George Orwell"
  book.edition 1
  book.avail_copies 2
  book.total_num_copies 2
end

Factory.define :user do |user|
  user.name "AprilClone"
  user.email "foobarclone@example.com"
  user.password "foobar"
  user.password_confirmation "foobar"
end

