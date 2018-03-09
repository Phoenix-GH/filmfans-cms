class Panel::CreateManualPostContainerForm
  include ActiveModel::Model

  attr_accessor(
      :name, :linked_manual_posts
  )

  validates :name, presence: true
  validate :at_least_one_linked_manual_post

  def initialize(attributes = {})
    @attributes = defaults.merge(attributes)
    super(@attributes)
  end

  def manual_post_container_attributes
    {
        name: name
    }
  end

  def linked_manual_posts_attributes=(attributes)
    @linked_manual_posts = set_linked_manual_posts(attributes)
  end

  def self.association(association, klass)
    @@attributes ||= {}
    @@attributes[association] = klass
  end

  def self.reflect_on_association(association)
    data = {klass: @@attributes[association]}
    OpenStruct.new data
  end

  association :linked_manual_posts, LinkedManualPost

  private

  def defaults
    {linked_manual_posts: []}
  end

  def set_linked_manual_posts(attributes)
    attributes.map do |i, params|
      LinkedManualPost.new(params)
    end.compact
  end

  def at_least_one_linked_manual_post
    if linked_manual_posts.blank?
      errors[:linked_manual_posts] << '- at least one must be present'
    end
  end
end
