class Api::V1::EventsController < Api::V1::BaseController
  def show
    event = Event.find(params[:id])

    render json: EventSerializer.new(event, with_content: true).results
  end
end
