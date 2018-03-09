class Panel::UpdateBenchmarkService
  def initialize(benchmark, form)
    @benchmark = benchmark
    @form = form
  end

  def call
    return false unless @form.valid?

    update
  end

  private

  def update
    @benchmark.update_attributes(@form.attributes.merge(
        {predicted_category: @benchmark.details['classifier']}))
  end

end