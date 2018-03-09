class IssuePageTag < ActiveRecord::Base
  belongs_to :issue_page
  has_many :issue_tag_products, -> { order('position asc') }, dependent: :destroy
  has_many :products, through: :issue_tag_products

  serialize :specification, JSON

end