class Panel::IssuesController < Panel::BaseController
  before_action :set_issue, only: [:destroy, :show, :edit, :update, :upload, :tags, :tag_products, :confirm]
  before_action :set_magazine, only: [:index, :new, :create, :destroy, :show, :edit, :update, :upload, :tags, :tag_products, :confirm]
  before_action :set_channel , only: [:index, :new, :create, :destroy, :show, :edit, :update]
  before_action :set_product_presenter, only: [:edit, :upload, :tags, :tag_products, :confirm]
  after_action :crawl_images, only: [:edit, :upload, :tags, :tag_products, :confirm]

  # before_action :set_presenter, only: [:new, :create, :edit, :update]

  # def index
  #   @issues = @magazine.issues.all # IssueQuery.new(issue_search_params).results
  # end

  def index
    @issues = IssueQuery.new(issue_search_params).results
  end

  def new
    authorize! :update, @channel
    @cover_image = IssueCoverImage.new
    @form = Panel::CreateIssueForm.new
  end

  def create
    authorize! :update, @channel

    @form = Panel::CreateIssueForm.new(issue_form_params.merge(magazine_id: @magazine.id))
    service = Panel::CreateIssueService.new(@form, current_user)

    if service.call
      redirect_to upload_panel_magazine_issue_path(@magazine, service.issue),
                  notice: _('Issue was successfully created.')
    else
      render :new
    end
  end

  def show
    # Without :action show, access direct via url cause an exception
    # Redirect to edit page in case user go to issue by direct url
    # Ex: /issues/1 redirect to /issues/1/edit
    redirect_to :action => 'edit'
  end

  def edit
    authorize! :update, @channel

    form_attributes = issue_attributes
    if @issue.pdf_pages
      form_attributes = form_attributes.merge({pdf_pages_not_save: @issue.pdf_pages})
    end

    @form = Panel::UpdateIssueForm.new(form_attributes)
    @cover_image = @issue.cover_image

    render :edit
  end

  def update
    authorize! :update, @channel

    @form = Panel::UpdateIssueForm.new(
      issue_attributes,
      issue_form_params.merge(magazine_id: @magazine.id)
    )
    service = Panel::UpdateIssueService.new(@issue, @form)

    if service.call
      redirect_to upload_panel_magazine_issue_path(@magazine, @issue)
    else
      render :edit
    end
  end

  def destroy
    authorize! :update, @channel
    @issue.destroy

    redirect_to panel_magazine_issues_path(@magazine), notice: _('Issue was successfully deleted.')
  end

  def upload
  end

  def tags
  end

  def tag_products
  end

  def confirm
  end

  private

  def set_issue
    @issue = Issue.find(params[:id])
  end

  def set_magazine
    @magazine = Magazine.find(params[:magazine_id])
  end

  def set_channel
    @channel = @magazine.channel
  end

  def set_presenter
    @presenter = AdminPresenter.new(current_admin)
  end

  def set_product_presenter
    @product_presenter = ProductsPresenter.new
  end

  def issue_attributes
    @issue.slice('title', 'pages', 'url', 'publication_date', 'cover_image')
  end

  def issue_search_params
    params.permit(:page, :magazine_id)
  end

  def issue_form_params
    params.require(:issue_form).permit(:title, :pages, :url, :publication_date, cover_image: [:file])
  end

  def crawl_images
    MagazineImagePageCrawlerJob.crawl_if_needed(@issue.id)
  end
end
