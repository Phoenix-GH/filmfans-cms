class ActorSerializer
  def initialize(actor)
    @actor = actor
  end

  def results
    return {} unless @actor
    generate_actor_json
    @actor_json
  end

  private
  def generate_actor_json
    @actor_json = {
      id: @actor.id.to_i,
      character: @actor.character.to_s,
      name: @actor.name.to_s
    }
  end
end
