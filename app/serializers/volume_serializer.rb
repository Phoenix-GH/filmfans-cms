class VolumeSerializer
  def initialize(volume)
    @volume = volume
  end

  def results
    return '' unless @volume
    generate_volume_json
    add_issues

    @volume_json
  end

  private
  def generate_volume_json
    @volume_json = {
      volume_id: @volume.id.to_i,
      volume_year: @volume.year.to_i,
      volume_issues_count: @volume.issues.count.to_i
    }
  end

  def add_issues
    issues = @volume.issues.map do |issue|
      IssueSerializer.new(issue).results
    end

    @volume_json.merge!(issues: issues)
  end
end
