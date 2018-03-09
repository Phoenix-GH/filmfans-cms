class SocialCategorySerializer
  def initialize(top_cats, social_categories)
    @top_social_categories = top_cats
    @social_categories = social_categories
  end

  def results
    return {} unless @social_categories && @top_social_categories
    generate_json
    @cats_json
  end

  private

  def generate_json

    @cats_json = {}
    generate_top_json
    generate_others_json
  end

  def generate_top_json
    @top_social_categories.each do |cat|
      unless cat.group_key.blank?
        @cats_json[cat.group_key] = serialize_top(cat)
      end
    end
  end

  def generate_others_json
    @cats_json['others'] = @social_categories.map { |c| serialize(c) }
  end

  def serialize_top(cat)
    top_cat_json = serialize(cat)
    top_cat_json.merge(
      {
          followings: SocialAccountFollowingQuery.new({:social_category_id => cat.id}, {distinct: false, :ignore_paginate => true}).results.map do |following|
          SocialAccountFollowingSerializer.new(following).results
        end
      })
  end
  def serialize(cat)
    {
      id: cat.id,
      name: cat.name,
      image_url: cat.try(:image).try(:url)
    }
  end
end
