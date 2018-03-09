class RemoveMediaContentWithoutMembership
  def call
    MediaContent
      .where(membership: nil)
      .where('created_at < ?', Date.today - 1.days)
      .destroy_all
  end
end
