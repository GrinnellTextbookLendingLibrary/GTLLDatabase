namespace :db do
          desc "Load test data from csv file"
          task :loadtest => :environment do
               require 'fastercsv'

               Rake::Task['db:reset'].invoke
               FasterCSV.foreach("gtllTest.csv") do |row|
                   Book.create( :authors => row[0], 
                                :name => row[1],
                                :edition => row[2],
                                :total_num_copies => row[3],
                                :avail_copies => row[3]
                                )             
               end

              User.create!(:name => 'April',
                :email => 'example@test.com',
                :password => 'lemondrop',
                :password_confirmation => 'lemondrop')
         
           end
end
