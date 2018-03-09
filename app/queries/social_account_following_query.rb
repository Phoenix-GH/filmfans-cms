class SocialAccountFollowingQuery < BaseQuery
  attr_reader :options
  def initialize(filters = {}, options = {})
    super(filters)
    @options = options
  end

  def results
    prepare_query
    search_social_account_name
    category_filter
    search_result
    eager_load_option
    unique_target_id
    trending_filter
    order_results

    unless options[:ignore_paginate] == true
      paginate_result
    end
    select

    @results
  end

  private
  def prepare_query
    @results = SocialAccountFollowing.all.joins(:social_account)
  end

  def search_result
    return if filters[:search].blank?
    @results = @results.search_by_name(filters[:search]).with_pg_search_rank
  end

  def search_social_account_name
    return if filters[:social_account_name].blank?

    @results = @results.joins(:social_account).where("LOWER(CAST( #{'social_accounts.name'} AS text )) LIKE ?", "%#{filters[:social_account_name].downcase}%")
  end

  def eager_load_option
    return if options[:eager_load].blank?
    @results = @results.includes(options[:eager_load])
  end

  def category_filter
    return if filters[:social_category_id].blank?
    @results = @results.joins(:social_account_following_categories).where(social_account_following_categories: {social_category_id: filters[:social_category_id]}).order("social_account_following_categories.position ASC NULLS LAST")
  end

  def select
    return if options[:select].blank?
    @results = @results.select(options[:select])
  end

  def unique_target_id
    return unless options[:distinct] == true
    @results = @results.where(ordinal: 1)
  end

  def trending_filter
    return if filters[:trending].blank?
    @results = @results.joins(:social_account_following_categories).where(social_account_following_categories: {trending: filters[:trending]}).order("social_account_following_categories.position ASC NULLS LAST")
  end
end
