class Panel::CreateIssuePageService

  def initialize(form)
    @form = form
  end

  def call
    return false unless @form.valid?

    create_issue_page
  end

  private
  def create_issue_page
    issue_page = IssuePage.new(@form.attributes)
    issue_page.image = @form.image_attributes
    issue_page.save!
  end

end
