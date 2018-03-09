class Role < ClassyEnum::Base
end

class Role::Viewer < Role
  def index
    -1
  end

  def text
    _("Viewer")
  end
end

class Role::Curator < Role
  def index
    0
  end

  def text
    _("Curator")
  end
end

class Role::Moderator < Role
  def index
    1
  end

  def text
    _("Moderator")
  end
end

class Role::Admin < Role
  def index
    2
  end

  def text
    _("Admin")
  end
end

class Role::SuperAdmin < Role
  def index
    3
  end

  def text
    _("SuperAdmin")
  end
end
