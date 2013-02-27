namespace :db do
          desc "Load real records from csv file"
          task :loadreal => :environment do
               require 'fastercsv'

               Rake::Task['db:reset'].invoke
               FasterCSV.foreach("Library_Records_Feb_25_2013.csv") do |row|
                   avail = row[3]
                   if avail.nil?
                      avail = 1
                   end                   
                   Book.create( :authors => row[0], 
                                :name => row[1],
                                :edition => row[2],
                                :total_num_copies => avail,
                                :avail_copies => avail
                                )             
               end

              Manager.create!(:name => 'April',
                :email => 'example@test.com',
                :password => 'lemondrop',
                :password_confirmation => 'lemondrop')
         
           end
end
