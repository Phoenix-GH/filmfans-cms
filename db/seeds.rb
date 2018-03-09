puts 'Create superadmin'

Admin.create(email: 'admin@hotspotting.com', password: 'neko2016', active: true, role: 'super_admin')

puts 'Create admins'

Admin.create(email: 'admin2@hotspotting.com', password: 'neko2016', active: true)
Admin.create(email: 'admin3@hotspotting.com', password: 'neko2016', active: true)

puts 'Create media owners'

owner1 = MediaOwner.create(name: 'Chrissy Teigen', url: 'https://www.instagram.com/bellathorne/')
owner1.create_picture(remote_file_url: 'https://s3-ap-southeast-1.amazonaws.com/media.hotspotting.dev.sin/uploads/celebrity/picture/1/bella_thorne_ava.jpg')
owner2 = MediaOwner.create(name: 'Heidi Klum')
owner2.create_picture(remote_file_url: 'https://s3-ap-southeast-1.amazonaws.com/media.hotspotting.dev.sin/uploads/celebrity/picture/13/Heidiklum.jpg')
owner3 = MediaOwner.create(name: 'Bella Thorne')
owner3.create_picture(remote_file_url: 'https://s3-ap-southeast-1.amazonaws.com/media.hotspotting.dev.sin/uploads/celebrity/picture/12/bella_thorne_banner.jpg')

puts 'Create categories'

if Category.count == 0
  Rake::Task['create_categories'].invoke
end

woman_category = Category.find_by(name: 'Woman')
woman_category.update_attributes(
    remote_image_url: 'http://52.77.208.178/pictures/app/woman.jpg',
    remote_icon_url: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQG5prvnETGyEt0cGfdIUbzgtew7A8krGosqrVZ-ucJJPj9Hdbyyh2xZw'
)

man_category = Category.find_by(name: 'Man')
man_category.update_attributes(
    remote_image_url: 'http://52.77.208.178/pictures/app/man.jpg',
    remote_icon_url: 'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcRvEkV09Uk8LM1Yz9YM_Pkz1Idbhce7_Q1eK2AztFwhhCQm1Mpa7FH58VRcLQ'
)

puts 'Create option types and values'

ssize = OptionType.create(
    name: "size"
)
ccolor = OptionType.create(
    name: "color"
)
pprice = OptionType.create(
    name: "price"
)

size = OptionType.create(
    name: "t-shirt-size"
)
color = OptionType.create(
    name: "t-shirt-color"
)

size_medium = OptionValue.create(
    option_type: size,
    name: 'Medium'
)

size_large = OptionValue.create(
    option_type: size,
    name: 'Large'
)

color_blue = OptionValue.create(
    option_type: color,
    name: 'Blue'
)

color_green = OptionValue.create(
    option_type: color,
    name: 'Green'
)

puts 'Create media_containers/ tags and products for Chrissy Teigen'

container1 = MediaContainer.create(
    name: 'Chrissy Teigen outfit',
    owner: owner1,
    description: 'sample'
)
MediaContent.create(
    membership: container1,
    remote_cover_image_url: 'https://s3-ap-southeast-1.amazonaws.com/media.hotspotting.dev.sin/uploads/outfit/image/128/Birthday.jpg',
    remote_file_url: 'https://s3-ap-southeast-1.amazonaws.com/media.hotspotting.dev.sin/uploads/outfit/image/128/Birthday.jpg'
)

product1 = Product.create(
    name: 'Chloé',
    brand: 'brand'
)

pf1 = ProductFile.new({
                          product_id: product1.id,
                          remote_cover_image_url: 'https://s3-ap-southeast-1.amazonaws.com/media.hotspotting.dev.sin/uploads/product/image/56/Chloe.jpg',
                          remote_file_url: 'https://s3-ap-southeast-1.amazonaws.com/media.hotspotting.dev.sin/uploads/product/image/56/Chloe.jpg'
                      })
pf1.save
product1.product_files = pf1
product1.save

variant11 = Variant.create(product: product1, option_values: [size_medium, color_green])
variant12 = Variant.create(product: product1, option_values: [size_large, color_green])
variant13 = Variant.create(product: product1, option_values: [size_medium, color_blue])
ProductOptionType.create(product: product1, option_type: size)
ProductOptionType.create(product: product1, option_type: color)

Store.find_or_create_by(
    id: 10001,
    name: 'Amazon'
)

Store.find_or_create_by(
    id: 10000,
    name: 'Manually added products'
)


VariantStore.create(
    price: 12.2,
    currency: 'USD',
    url: 'https://www.net-a-porter.com/us/en/product/616971',
    variant: variant11
)

VariantStore.create(
    price: 13,
    currency: 'USD',
    url: 'https://www.net-a-porter.com/us/en/product/616971',
    variant: variant12
)

VariantStore.create(
    price: 12.2,
    currency: 'PLN',
    url: 'https://www.net-a-porter.com/us/en/product/616971',
    variant: variant13
)

Tag.create(
    media_container: container1,
    product: product1,
    coordinate_x: 0.5,
    coordinate_y: 0.95
)

shoes_category = Category.find_by(name: 'Shoes')
shoes_category.update_attributes(
    remote_image_url: 'https://s3-ap-southeast-1.amazonaws.com/media.hotspotting.dev.sin/uploads/garment/image/3/SHOES.jpg',
    remote_icon_url: 'https://s3-ap-southeast-1.amazonaws.com/media.hotspotting.dev.sin/uploads/garment/icon/3/SHOES.png'
)

ProductCategory.create(category: shoes_category, product: product1)

puts 'Create media_containers/ tags and products for Heidi Klum'

container2 = MediaContainer.create(
    name: 'Heidi Klum outfit',
    owner: owner2,
    description: 'sample'
)
MediaContent.create(
    membership: container2,
    remote_cover_image_url: 'https://s3-ap-southeast-1.amazonaws.com/media.hotspotting.dev.sin/uploads/outfit/image/134/HeidiklumAustralia.jpg',
    remote_file_url: 'https://s3-ap-southeast-1.amazonaws.com/media.hotspotting.dev.sin/uploads/outfit/image/134/HeidiklumAustralia.jpg'
)

product2 = Product.create(
    name: 'SAINT LAURENT',
    brand: 'brand'
)
pf2 = ProductFile.new(
    product_id: product2.id,
    remote_cover_image_url: 'https://s3-ap-southeast-1.amazonaws.com/media.hotspotting.dev.sin/uploads/product/image/71/SAINTLAURENT4.jpg',
    remote_file_url: 'https://s3-ap-southeast-1.amazonaws.com/media.hotspotting.dev.sin/uploads/product/image/71/SAINTLAURENT4.jpg'
)
pf2.save
product2.product_files = pf2
product2.save

variant21 = Variant.create(product: product2, option_values: [size_medium, color_green])
variant22 = Variant.create(product: product2, option_values: [size_large, color_green])
variant23 = Variant.create(product: product2, option_values: [size_medium, color_blue])
ProductOptionType.create(product: product2, option_type: size)
ProductOptionType.create(product: product2, option_type: color)

VariantStore.create(
    price: 133.2,
    currency: 'USD',
    url: 'http://www.matchesfashion.com/us/products/1039604?country=USA&qxjkl=tsid:38929%7Ccgn:J84DHJLQkR4&c3ch=LinkShare&c3nid=J84DHJLQkR4',
    variant: variant21
)
VariantStore.create(
    price: 130.0,
    currency: 'USD',
    url: 'http://www.matchesfashion.com/us/products/1039604?country=USA&qxjkl=tsid:38929%7Ccgn:J84DHJLQkR4&c3ch=LinkShare&c3nid=J84DHJLQkR4',
    variant: variant22
)
VariantStore.create(
    price: 133.2,
    currency: 'PLN',
    url: 'http://www.matchesfashion.com/us/products/1039604?country=USA&qxjkl=tsid:38929%7Ccgn:J84DHJLQkR4&c3ch=LinkShare&c3nid=J84DHJLQkR4',
    variant: variant23
)

Tag.create(
    media_container: container2,
    product: product2,
    coordinate_x: 0.55,
    coordinate_y: 0.1
)

glasses_category = Category.find_by(name: 'Sunglasses')
glasses_category.update_attributes(
    remote_image_url: 'https://s3-ap-southeast-1.amazonaws.com/media.hotspotting.dev.sin/uploads/garment/image/4/GLASSES.jpg',
    remote_icon_url: 'https://s3-ap-southeast-1.amazonaws.com/media.hotspotting.dev.sin/uploads/garment/icon/4/GLASSES.png'
)

ProductCategory.create(category: glasses_category, product: product2)

puts 'Create media_containers/ tags and products for Bella Thorne'

container3 = MediaContainer.create(
    name: 'Mexico Glamour',
    owner: owner3,
    description: 'sample'
)
MediaContent.create(
    membership: container3,
    remote_cover_image_url: 'https://s3-ap-southeast-1.amazonaws.com/media.hotspotting.dev.sin/uploads/outfit/image/88/BTGlamourNew.jpg',
    remote_file_url: 'https://s3-ap-southeast-1.amazonaws.com/media.hotspotting.dev.sin/uploads/outfit/image/88/BTGlamourNew.jpg'
)

product3 = Product.create(
    name: 'Lexia',
    brand: 'brand Lexia'
)

pf3 = ProductFile.new(
    product_id: product3.id,
    large_version_url: 'http://ecx.images-amazon.com/images/I/51Kl2VufhtL._UL1500_.jpg',
    normal_version_url: 'http://ecx.images-amazon.com/images/I/31ON35cK1xL.jpg',
    small_version_url: 'http://ecx.images-amazon.com/images/I/31ON35cK1xL._SR38,50_.jpg'
)
pf3.save
product3.product_files = pf3
product3.save

variant31 = Variant.create(product: product3, option_values: [size_medium, color_green])
variant32 = Variant.create(product: product3, option_values: [size_large, color_green])
variant33 = Variant.create(product: product3, option_values: [size_medium, color_blue])
ProductOptionType.create(product: product3, option_type: size)
ProductOptionType.create(product: product3, option_type: color)

VariantStore.create(
    price: 133.2,
    currency: 'USD',
    url: 'http://www.matchesfashion.com/us/products/1039604?country=USA&qxjkl=tsid:38929%7Ccgn:J84DHJLQkR4&c3ch=LinkShare&c3nid=J84DHJLQkR4',
    variant: variant31
)
VariantStore.create(
    price: 130.0,
    currency: 'USD',
    url: 'http://www.matchesfashion.com/us/products/1039604?country=USA&qxjkl=tsid:38929%7Ccgn:J84DHJLQkR4&c3ch=LinkShare&c3nid=J84DHJLQkR4',
    variant: variant32
)
VariantStore.create(
    price: 133.2,
    currency: 'PLN',
    url: 'http://www.matchesfashion.com/us/products/1039604?country=USA&qxjkl=tsid:38929%7Ccgn:J84DHJLQkR4&c3ch=LinkShare&c3nid=J84DHJLQkR4',
    variant: variant33
)

Tag.create(
    media_container: container3,
    product: product3,
    coordinate_x: 0.57,
    coordinate_y: 0.28
)

dresses_category = Category.find_by(name: 'Dresses')
dresses_category.update_attributes(
    remote_image_url: 'https://s3-ap-southeast-1.amazonaws.com/media.hotspotting.dev.sin/uploads/garment/image/1/DRESSES.jpg',
    remote_icon_url: 'https://s3-ap-southeast-1.amazonaws.com/media.hotspotting.dev.sin/uploads/garment/icon/1/DRESSES.jpg'
)

ProductCategory.create(category: dresses_category, product: product3)

puts 'Create collection'

products_container = ProductsContainer.create(
    name: 'Super products'
)

LinkedProduct.create(
    product: product1,
    products_container: products_container,
    position: 1
)

LinkedProduct.create(
    product: product2,
    products_container: products_container,
    position: 2
)

collection = Collection.create(name: 'Mothers day')

CollectionContent.create(
    collection: collection,
    content: products_container,
    position: 1
)

CollectionContent.create(
    collection: collection,
    content: container3,
    position: 2
)
