class Panel::ProductImageIndexesController < Panel::BaseController
  def index
    @data_rows= ProductImageCsvExportQuery.new(search_params).results
  end

  def export_now
    ExportProductImageCsvWorker.perform_async
    redirect_to panel_product_image_indexes_path, notice: _('Export job was sent to sidekiq')
  end

  private

  def search_params
    params.permit(:sort, :direction, :system)
  end

  def sort_column
    ['system', 'created_at'].include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : (sort_column == 'created_at' ? 'desc' : 'asc')
  end
end