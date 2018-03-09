class Provider < ClassyEnum::Base
end

class Provider::Instagram < Provider
  def index
    0
  end

  def text
    _("Instagram")
  end
end

class Provider::Facebook < Provider
  def index
    1
  end

  def text
    _("Facebook")
  end
end

class Provider::Google < Provider
  def index
    2
  end

  def text
    _("Google")
  end
end
