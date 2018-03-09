class ProfileSerializer
  def initialize(profile)
    @profile = profile
  end

  def results
    return {} unless @profile

    generate_profile_json
  end

  private
  def generate_profile_json
    @profile_json = {
        name: @profile.name.to_s,
        surname: @profile.surname.to_s,
        sex: @profile.sex.to_s,
        birthday: @profile.birthday.to_s,
        picture: @profile.picture.url.to_s
    }
  end
end
