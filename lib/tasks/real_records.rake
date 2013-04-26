namespace :db do
          desc "Load real records from csv file"
          task :loadreal => :environment do
               require 'csv'

               Rake::Task['db:reset'].invoke
               CSV.foreach("Library_Records_Feb_25_2013.csv") do |row|
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

             @April =   User.create!(:name => 'April',
                                           :email => 'example@test.com',
                                           :password => 'lemondrop',
                                           :password_confirmation => 
                                           'lemondrop')
             @April.save
             @April.manager = true
             @April.save              
           end
end
