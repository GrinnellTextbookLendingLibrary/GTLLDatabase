namespace :db do
          desc "Fill database with sample data"
          task :populate => :environment do
               Rake::Task['db:reset'].invoke
               Book.create!(:name => "Five",
                            :authors => "Joe Smith",
                            :edition => 1,
                            :avail_copies => 5,
                            :total_num_copies => 87)
               999.times do |n|
                        name = "Book #{n+1}"
                        authors = Faker::Name.name
                        (n%10-1).times do
                                   authors.concat(", " + Faker::Name.name)
                        end
                        
                        Book.create!(:name => name, 
                                      :authors => authors,
                                      :edition => (n+5)%90+1,
                                      :avail_copies => (n+4)%7+2,
                                      :total_num_copies => (n+4)%7+4)
                        end  
                        
              Manager.create!(:name => 'April',
                :email => 'example@test.com',
                :password => 'lemondrop',
                :password_confirmation => 'lemondrop')
         
           end
end 
