class ProductFilesJsonSerializer

  def self.dump(hash)
    return [] if hash.blank? or hash == [{}]
    if hash.is_a?(Hash)
      hash.to_json
    elsif hash.is_a?(Array)
      resp = []
      hash.each do |h|
        if h.is_a?(ProductFile)
          resp << h.attributes
        elsif h.is_a?(Hash)
          resp << h
        end
      end
      resp.to_json
    elsif hash.is_a?(ProductFile)
      return hash.attributes
    end
  end

  def self.load(hash)
    return [] if hash.blank? or hash == [{}]
    pfs = []
    if hash.is_a?(Array)
      hash.each do |h|
        if h.is_a?(ProductFile)
          pfs << h
        elsif h.is_a?(Hash)
          p = ProductFile.new(h)
          pfs << p
        end
      end
      return pfs
    elsif hash.is_a?(Hash)
      p = ProductFile.new(hash)
      p.save
      pfs << p
      return pfs
    elsif hash.is_a?(ProductFile)
      return hash
    end
  end
end
