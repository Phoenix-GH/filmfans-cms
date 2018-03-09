class IssueTagCategories
  ICON_PATH_PREFIX = 'icons/issue-tag-category/'
  CATEGORIES = [
      {type: 'activewear', label: 'Activewear'},
      {type: 'bags', label: 'Bags'},
      {type: 'beauty', label: 'Beauty'},
      {type: 'belts', label: 'Belts'},
      {type: 'bodysuits', label: 'Bodysuits'},
      {type: 'bralette', label: 'Bralette'},
      {type: 'dresses', label: 'Dresses'},
      {type: 'gifts', label: 'Gifts'},
      {type: 'glasses', label: 'Glasses'},
      {type: 'gloves', label: 'Gloves'},
      {type: 'grooming', label: 'Grooming'},
      {type: 'hats', label: 'Hats'},
      {type: 'home', label: 'Home'},
      {type: 'jackets', label: 'Jackets'},
      {type: 'jewelry', label: 'Jewelry'},
      {type: 'jumpsuits', label: 'Jumpsuits'},
      {type: 'lingerie', label: 'Lingerie'},
      {type: 'overalls', label: 'Overalls'},
      {type: 'pajamas', label: 'Pajamas'},
      {type: 'pants', label: 'Pants'},
      {type: 'perfume', label: 'Perfume'},
      {type: 'polish', label: 'Polish'},
      {type: 'poncho', label: 'Poncho'},
      {type: 'ring', label: 'Ring'},
      {type: 'scarves', label: 'Scarves'},
      {type: 'shirts', label: 'Shirts'},
      {type: 'shoes', label: 'Shoes'},
      {type: 'shorts', label: 'Shorts'},
      {type: 'skirts', label: 'Skirts'},
      {type: 'suits', label: 'Suits'},
      {type: 'sweaters', label: 'Sweaters'},
      {type: 'swimwear', label: 'Swimwear'},
      {type: 'ties', label: 'Ties'},
      {type: 'tights', label: 'Tights'},
      {type: 'tops', label: 'Tops'},
      {type: 'underwear', label: 'Underwear'},
      {type: 'vests', label: 'Vests'},
      {type: 'watches', label: 'Watches'},
  ]

  def self.all
    CATEGORIES
  end

  def self.icon_url(type)
    ActionController::Base.helpers.image_url(ICON_PATH_PREFIX + type + '_category.png')
  end
end