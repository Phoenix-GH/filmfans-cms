class Panel::UpdateBenchmarkForm
  include ActiveModel::Model

  attr_accessor(
      :review, :retrained_category, :comment
  )

  validates :review, presence: true
  validate :category_matches_review

  def initialize(benchmark_attrs, form_attributes = {})
    if form_attributes[:retrained_category].blank?
      form_attributes[:retrained_category] = nil
    else
      form_attributes[:retrained_category] = Category.find(form_attributes[:retrained_category]).imaging_category
    end

    super benchmark_attrs.merge(form_attributes)
  end

  def attributes
    {
        review: review,
        retrained_category: retrained_category,
        comment: comment
    }
  end

  private

  def category_matches_review
    if review == 'PRS_W_CATE' && retrained_category.blank?
      errors[:retrained_category] << 'must select one category for retraining'
    end
    if review != 'PRS_W_CATE' && !retrained_category.blank?
      errors[:retrained_category] << 'do not select any category for retraining'
    end
  end
end