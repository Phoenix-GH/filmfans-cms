class Json::EventsController < ApplicationController
  def index
    events = EventQuery.new(search_params).results

    render json: events.map { |event|
      {
        id: event.id,
        text: event.name,
        image: event.cover_image&.custom_url
      }
    }
  end

  private

  def search_params
    params.permit(:search).merge(admin_id: current_admin.id)
  end
end
