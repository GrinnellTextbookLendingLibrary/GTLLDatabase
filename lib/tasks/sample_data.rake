namespace :db do
          desc "Fill database with sample data"
          task :populate => :environment do
               Rake::Task['db:reset'].invoke
               Book.create!(:name => "Five",
                            :authors => "Joe Smith",
                            :edition => 1,
                            :num_copies => 5)
               99.times do |n|
                        name = "Book #{n+1}"
                        authors = Faker::Name.name
                        Book.create!(:name => name, 
                                      :authors => authors,
                                      :edition => 1,
                                      :num_copies => 2)
                        end  
                        
              Manager.create!(:name => 'April',
                :email => 'example@test.com',
                :password => 'lemondrop',
                :password_confirmation => 'lemondrop')
         
           end
end 
