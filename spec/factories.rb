
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

Factory.define :manager, :class => User do |manager|
  manager.name "KateClone"
  manager.email "foobarklone@example.com"
  manager.password "foobar"
  manager.password_confirmation "foobar"
  manager.manager true
end



=begin             FACTORYGIRL 4.0 syntax
FactoryGirl.define do
  factory :book do
    name "Animal Farm"
    authors "George Orwell"
    edition 1
    avail_copies 2
    total_num_copies 2
  end

  factory :user do
    name "AprilClone"
    email "foobarclone@example.com"
    password "foobar"
    password_confirmation "foobar"  

    factory :manager do
      manager true
    end
  end
end
=end 




