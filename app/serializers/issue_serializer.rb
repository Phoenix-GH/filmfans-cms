class IssueSerializer
  def initialize(issue)
    @issue = issue
  end

  def results
    return '' unless @issue
    generate_issue_json
  end

  private
  def generate_issue_json
    {
      issue_id: @issue.id.to_i,
      issue_publication_month: @issue.publication_date&.strftime("%B").to_s,
      issue_publication_year: @issue.volume&.year.to_i,
      issue_description: @issue.description.to_s,
      issue_title: @issue.title.to_s,
      issue_cover_image_url: @issue.cover_image.present? ? @issue.cover_image.custom_url : '',
      issue_url: @issue.url.to_s,
      issue_pages: @issue.pages.to_i
    }
  end
end
