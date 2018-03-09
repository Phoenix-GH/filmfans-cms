task add_magazines_to_db: :environment do
  AddMagazinesFromDropboxToDb.new.call
end
