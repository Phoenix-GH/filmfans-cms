class SocialAccountFollowing < ActiveRecord::Base
  include PgSearch

  belongs_to :social_account
  has_many :social_account_following_categories
  has_many :social_categories, through: :social_account_following_categories

  pg_search_scope :search_by_name, against: :name,
                  :order_within_rank => 'social_account_followings.name ASC',
                  using: { tsearch: { :tsvector_column => 'tsv', prefix: true } }

  def followers_num
    return nil if information.blank? || information['followed_by'].blank?
    information['followed_by']
  end

  def followers_num_pretty
    pretty_num(followers_num)
  end

  def posts_num
    return nil if information.blank? || information['number_posts'].blank?
    information['number_posts']
  end

  def posts_num_pretty
    pretty_num(posts_num)
  end


  private

  def pretty_num(num)
    return '' if num.blank?
    number = num.to_i

    if number >= 1000
      number = (number / 1000).round
      return "#{ActiveSupport::NumberHelper.number_to_delimited(number)}K"
    elsif number >= 1000000
      number = (number / 1000000).round
      return "#{ActiveSupport::NumberHelper.number_to_delimited(number)}K"
    elsif number >= 1000000000
      number = (number / 1000000000).round
      return "#{ActiveSupport::NumberHelper.number_to_delimited(number)}K"
    end

    ActiveSupport::NumberHelper.number_to_delimited(number)
  end
end
