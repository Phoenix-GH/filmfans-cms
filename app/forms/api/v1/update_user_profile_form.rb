class Api::V1::UpdateUserProfileForm
  include ActiveModel::Model

  attr_accessor(
    :name, :surname, :sex, :birthday, :picture, :picture_name
  )

  validates :name, :surname, presence: true, allow_blank: false
  validates :sex, gender: true
  validates :birthday, date: true

  def user_profile_attributes
    {
      name: name,
      surname: surname,
      sex: sex,
      birthday: birthday,
      picture: picture,
      picture_name: picture_name
    }
  end
end
