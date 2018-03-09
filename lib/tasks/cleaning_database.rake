namespace :cleaning_database do
  desc "TODO"
  task media_content: :environment do
    RemoveMediaContentWithoutMembership.new.call
  end
end
