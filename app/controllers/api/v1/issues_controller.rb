class Api::V1::IssuesController < Api::V1::BaseController
  def initialize(params = {})
    @dummy_product_id = 0;
  end

  def issue_pages
    issue = Issue.find(params[:issue_id])

    pages = issue.issue_pages&.includes(:issue_page_tags)&.reject { |page| !page.visible }&.map do |page|
      IssuePageSerializer.new(page).results
    end

    render json: {
        pages: pages
    }
  end

end