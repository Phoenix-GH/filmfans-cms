class VariantFilesJsonSerializer

  def self.dump(hash)
    return [] if hash.blank? or hash == [{}]
    if hash.is_a?(Hash)
      hash.to_json
    elsif hash.is_a?(Array)
      resp = []
      hash.each do |h|
        if h.is_a?(VariantFile)
          resp << h.attributes
        elsif h.is_a?(Hash)
          resp << h
        end
      end
      resp.to_json
    elsif hash.is_a?(VariantFile)
      return hash.attributes
    end
  end

  def self.load(hash)
    return [] if hash.blank? or hash == [{}]
    vfs = []
    if hash.is_a?(Array)
      hash.each do |h|
        if h.is_a?(VariantFile)
          vfs << h
        elsif h.is_a?(Hash)
          p = VariantFile.new(h)
          vfs << p
        end
      end
      return vfs
    elsif hash.is_a?(Hash)
      p = VariantFile.new(hash)
      p.save
      vfs << p
      return vfs
    elsif hash.is_a?(VariantFile)
      return hash
    end
  end
end
