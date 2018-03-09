task dialogfeed_sync: :environment do
  puts 'Starting update jobs for Media Owners...'
  count = 0
  MediaOwner.all.each do |mo|
    count += 1 if mo.update_dialogfeed(remove_old = false)
  end
  puts "Started! Number of Media Owners with Dialogfeed URL: #{count}"
  puts 'Starting update jobs for Channels...'
  count = 0
  Channel.all.each do |c|
    count += 1 if c.update_dialogfeed(remove_old = false)
  end
  puts "Started! Number of Channels with Dialogfeed URL: #{count}"
end
