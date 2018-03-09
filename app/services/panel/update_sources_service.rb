class Panel::UpdateSourcesService

  def initialize(source_owner, dialogfeed_sources)
    @source_owner = source_owner
    @dialogfeed_sources = dialogfeed_sources
  end

  def call
    @source_owner.sources.each do |source|
      # Destroy source unless dialogfeed source exists
      destroy = true

      @dialogfeed_sources.each do |df_source|
        if df_source['id'] == source.dialogfeed_id

          # Update source if needed
          if df_source['name'] != source.name
            source.name = df_source['name']
            source.save
          end

          # Do not destroy source
          destroy = false
          break
        end
      end

      source.destroy if destroy
    end
  end

end