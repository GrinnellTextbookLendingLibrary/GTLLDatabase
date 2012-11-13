Factory.define :book do |book|
  book.name "Animal Farm"
  book.authors "George Orwell"
  book.edition 1
  book.num_copies 2
end

Factory.define :manager do |manager|
  manager.name "April"
  manager.email "foobar@example.com"
  manager.password "foobar"
  manager.password_confirmation "foobar"
end

