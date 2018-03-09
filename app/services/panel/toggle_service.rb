class Panel::ToggleService
  def initialize(source, source_column)
    @source = source
    @source_column = source_column
  end

  def call
    if @source[@source_column]
      @source.update_attribute(@source_column, false)
    else
      @source.update_attribute(@source_column, true)
    end
  end
end