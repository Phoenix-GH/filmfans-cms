task add_homes_to_db: :environment do
  AddHomesFromDropboxToDb.new.call
end
