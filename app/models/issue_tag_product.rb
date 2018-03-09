class IssueTagProduct < ActiveRecord::Base
  belongs_to :issue_page_tag
  belongs_to :product
end