class Panel::SupportController < Panel::BaseController
  def index
    @form = Panel::SupportEnquiryForm.new
  end

  def enquiry
    @form = Panel::SupportEnquiryForm.new(enquiry_form_params)
    if @form.valid?
      SupportMailer.support_enquiry(current_admin, @form.subject, @form.content).deliver
      redirect_to panel_support_index_path, notice: _('Your enquiry was successfully sent.')
    else
      render :index
    end
  end

  private
  def enquiry_form_params
    params.require(:enquiry_form).permit(:subject, :content)
  end
end
