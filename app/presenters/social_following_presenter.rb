class SocialFollowingPresenter
  def initialize(*)
    super
  end

  def categories
    cats = []
    SocialCategoryQuery.new.results.each { |cat|
      cats << [cat.name, cat.id]
    }

    cats
  end
end
