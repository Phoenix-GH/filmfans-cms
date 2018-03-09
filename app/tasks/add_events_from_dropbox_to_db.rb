class AddEventsFromDropboxToDb
  def call
    ActiveRecord::Base.transaction do
      create_events
      add_events_to_home
    end
  end

  private
  def create_events
    puts 'Create event 1'
    owner = Channel.find_by(name: 'Reve')

    @event = Event.create(name: 'Billboard Music Awards 2016')
    @event.create_cover_image(remote_file_url: 'http://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/temp/events/Event%201/T71126286_Max.jpg')
    @event.create_background_image(remote_file_url: 'http://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/temp/events/Event%201/T71126286_Max.jpg')

    media_container1 = MediaContainer.create(owner: owner, name: 'Ariana Grande', description: 'Ariana Grande arrives at the 2016 Billboard Music Awards pink carpet in Las Vegas.')
    media_container2 = MediaContainer.create(owner: owner, name: 'The Weekend', description: 'The Weekend arrives at the 2016 Billboard Music Awards press room in Las Vegas.')
    media_container3 = MediaContainer.create(owner: owner, name: 'Ciara', description: 'Ciara arrives at the Billboard Music Awards 2016')
    MediaContent.create(remote_file_url: 'http://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/temp/events/Event%201/SPL1289083.mp4', membership: media_container1)
    MediaContent.create(remote_file_url: 'http://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/temp/events/Event%201/SPL1288408.mp4', membership: media_container2)
    MediaContent.create(remote_file_url: 'http://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/temp/events/Event%201/SPL1288683.mp4', membership: media_container3)
    EventContent.create(
      event: @event,
      content: media_container1,
      position: 1,
      width: 'full'
    )
    EventContent.create(
      event: @event,
      content: media_container2,
      position: 2,
      width: 'full'
    )
    EventContent.create(
      event: @event,
      content: media_container3,
      position: 3,
      width: 'full'
    )

    puts 'Create event 2'

    @event2 = Event.create(name: 'Guillaume Henry X Nina Ricci')
    @event2.create_cover_image(remote_file_url: 'http://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/temp/events/Event%202/Guillaume%20Henry%20X%20Nina%20Ricci.jpg')
    @event2.create_background_image(remote_file_url: 'http://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/temp/events/Event%202/Guillaume%20Henry%20X%20Nina%20Ricci.jpg')

    media_container4 = MediaContainer.create(owner: owner, name: 'Nina Ricci', description: 'Models and designer Guillaume Henry on the Nina Ricci Runway')
    MediaContent.create(remote_file_url: 'http://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/temp/events/Event%202/Models%20and%20designer%20Guillaume%20Henry%20on%20the%20Nina%20Ricci%20Runway.mp4', membership: media_container4)
    EventContent.create(
      event: @event2,
      content: media_container4,
      position: 1,
      width: 'full'
    )

  end

  def add_events_to_home
    puts 'Create events container'
    @home = Home.last
    add_events_container
  end

  def add_events_container
    event_container = EventsContainer.create
    LinkedEvent.create(event: @event, events_container: event_container, position: 1)
    LinkedEvent.create(event: @event2, events_container: event_container, position: 2)

    @home.home_contents.create(content: event_container, position: 6, width: 'full')
  end
end
