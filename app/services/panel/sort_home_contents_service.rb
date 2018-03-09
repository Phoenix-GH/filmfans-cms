class Panel::SortHomeContentsService
  def initialize(home, params)
    @home = home
    @params = params
  end

  def call
    update_all_positions
  end

  private

  def update_all_positions
    @params.each do |key, value|
      @home.home_contents
        .find(value[:id])
        .update_attribute(:position ,value[:position])
    end
  end
end
