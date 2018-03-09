task add_events_to_db: :environment do
  AddEventsFromDropboxToDb.new.call
end
