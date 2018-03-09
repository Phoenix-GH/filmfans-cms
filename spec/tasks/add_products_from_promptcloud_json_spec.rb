require "rake"
describe AddProductsFromPromptcloudJson do
  # before(:all) do
  #   Rails.application.load_tasks
  #   Rake::Task['create_categories'].invoke
  # end

  # before do
  #   products = File.read("#{Rails.root}/spec/fixtures/files/promptcloud_products.json")
  #   @json = ActiveSupport::JSON.decode(products)
  # end

  # it 'adds new products' do
  #   task = AddProductsFromPromptcloudJson.new(@json)
  #   expect{ task.call }.to change(Product, :count).by(3) #asin dupliaction
  #   test_product = Product.last
  #   expect(test_product.name).to eq 'Rudy Oops By Jay Missy Fit Open Bottom Sweatpant'
  #   expect(test_product.product_code).to eq '9eb90e105ba8d51f4451c61495bc6222'
  # end

  # it 'adds a new media content for each product' do
  #   task = AddProductsFromPromptcloudJson.new(@json)
  #   task.call

  #   product = Product.last
  #   expect(product.product_files.count).to eq 3

  #   test_content_first = product.product_files.first
  #   expect(test_content_first.file).not_to be_nil
  #   expect(test_content_first.product).not_to be_nil
  #   expect(test_content_first.cover_image).not_to be_nil
  #   test_content_last = product.product_files.last
  #   expect(test_content_last.file).not_to be_nil
  #   expect(test_content_last.product).not_to be_nil
  #   expect(test_content_last.cover_image).not_to be_nil
  # end

  # it 'adds a new media content for each variant' do
  #   task = AddProductsFromPromptcloudJson.new(@json)
  #   task.call

  #   product = Product.last
  #   expect(product.variants.last.variant_files.count).to eq 3

  #   test_content_last = product.variants.last.variant_files.last
  #   expect(test_content_last.small_version_url).not_to be_nil
  #   expect(test_content_last.variant).not_to be_nil
  #   expect(test_content_last.cover_image).not_to be_nil
  # end

  # it 'adds option types and values for each product' do
  #   task = AddProductsFromPromptcloudJson.new(@json)
  #   expect{ task.call }.to change(OptionType, :count).by(0)
  #   expect(OptionValue.count).to eq(11)
  #   expect(ProductOptionType.count).to eq(3)
  #   expect(OptionValueVariant.count).to eq(47)

  #   product = Product.first
  #   expect(product.variants.count).to eq(7)
  #   product = Product.last
  #   expect(product.variants.count).to eq(20)
  # end

  # it 'json without variants' do
  #   json = '{
  #     "root": {
  #       "page": [{
  #         "pageurl": "http://www.amazon.com/Port-Authority-Jacket-Pacific-Blue/dp/B0012GLDCU",
  #         "record": {
  #           "uniq_id": "0286f462b521a773e1ab03c6898f0140",
  #           "detail_pageurl": "http://www.amazon.com/Port-Authority-Jacket-Pacific-Blue/dp/B0012GLDCU",
  #           "title": "A PRODUCT WITHOUT VARIANTS",
  #           "innermost_category": "Shells",
  #           "department": "Shells",
  #           "product_name": "Port Authority - MRX Jacket, Pacific Blue/Grey, XS",
  #           "asin": "B0012GLDCU",
  #           "item_base_price": "$49.98",
  #           "category_hierarchy": ["Clothing, Shoes & Jewelry", "Men", "Clothing", "Jackets & Coats", "Active & Performance", "Shells"],
  #           "available_features": {
  #             "feature_0": "nylon",
  #             "feature_1": "78/22 nylon/cotton oxford shell",
  #             "feature_2": "100% polyester mesh upper body lining",
  #             "feature_3": "100% nylon taffeta lining on lower body and sleeves",
  #             "feature_4": "Locker loop",
  #             "feature_5": "Interior chest pocket with Velcro closure"
  #           },
  #           "images": {
  #             "default_image_links": {
  #               "mediumImage": "http://ecx.images-amazon.com/images/I/413uP-xCm6L.jpg",
  #               "smallImage": "http://ecx.images-amazon.com/images/I/413uP-xCm6L._SR38,50_.jpg"
  #             }
  #           }
  #         }
  #       }]
  #     }
  #   }'
  #   @json = ActiveSupport::JSON.decode(json)

  #   task = AddProductsFromPromptcloudJson.new(@json)
  #   expect{ task.call }.to change(Product, :count).by(1)
  #   expect{ task.call }.to change(Product, :count).by(0) #second call find by product_code
  #   test_product = Product.last
  #   expect(test_product.name).to eq 'Port Authority - MRX Jacket, Pacific Blue/Grey, XS'
  #   expect(test_product.product_code).to eq '0286f462b521a773e1ab03c6898f0140'

  #   expect(Variant.count).to eq(1)
  #   expect(OptionValue.count).to eq(0)
  #   expect(ProductOptionType.count).to eq(0)
  #   expect(OptionValueVariant.count).to eq(0)

  #   expect(VariantStore.count).to eq(1)
  #   test_store = VariantStore.last
  #   expect(test_store.url).to eq 'http://www.amazon.com/Port-Authority-Jacket-Pacific-Blue/dp/B0012GLDCU'
  #   expect(test_store.price).to eq 49.98
  #   expect(test_product.price_range).to eq "$49.98"
  #   expect(test_store.currency).to eq 'USD'
  #   expect(test_store.sku).to eq 'B0012GLDCU'
  #   expect(test_store.store_id).to eq Store.find_by(name: 'Amazon').id

  #   expect(ProductFile.count).to eq(1) #one for product
  #   test_product_file = ProductFile.last
  #   expect(test_product_file.small_version_url).to eq 'http://ecx.images-amazon.com/images/I/413uP-xCm6L._SR38,50_.jpg'
  #   expect(test_product_file.normal_version_url).to eq 'http://ecx.images-amazon.com/images/I/413uP-xCm6L.jpg'
  #   expect(test_product_file.large_version_url).to eq ''

  #   #product_similarity
  #   expect(ProductSimilarity.count).to eq(0)
  # end

  # it 'json with only size variants' do
  #   json = '{
  #     "root": {
  #       "page": [{
  #         "pageurl": "http://www.amazon.com/ABOUT-THINGS-Nordic-Skiing-Hoodie/dp/B00PVBWLZU",
  #         "record": {
  #           "uniq_id": "f5b532663251669a1f53482b1f728a77",
  #           "detail_pageurl": "http://www.amazon.com/ABOUT-THINGS-Nordic-Skiing-Hoodie/dp/B00PVBWLZU",
  #           "title": "A PRODUCT WITH VARIANTS AND ONLY DEFAULT IMAGES",
  #           "innermost_category": "Hoodies",
  #           "department": "Hoodies",
  #           "product_name": "I ONLY CARE ABOUT 2 THINGS SEX AND Nordic Skiing Women Hoodie",
  #           "asin": "B00PVBWLZU",
  #           "item_base_price": "$19.99 - $39.99",
  #           "category_hierarchy": ["Clothing, Shoes & Jewelry", "Novelty & More", "Clothing", "Novelty", "Women", "Hoodies"],
  #           "available_sizes": {
  #             "size_0": "X-Small",
  #             "size_1": "Small",
  #             "size_2": "Medium",
  #             "size_3": "Large",
  #             "size_4": "X-Large",
  #             "size_5": "XX-Large",
  #             "size_6": "XXX-Large"
  #           },
  #           "available_features": {
  #             "feature_0": "This is an authentic idakoos Nordic Skiing Hoodie",
  #             "feature_1": "High quality durable print. 100% Satisfaction Guarantee",
  #             "feature_2": "Hoddie 100% cotton for comfort and softness",
  #             "feature_3": "Great idea for gift on birthday present, holidays, or some special day",
  #             "feature_4": "Roomy front pocket pouch"
  #           },
  #           "images": {
  #             "default_image_links": {
  #               "largeImage": "http://ecx.images-amazon.com/images/I/71gfvFxQLlL._UL1500_.jpg",
  #               "mediumImage": "http://ecx.images-amazon.com/images/I/5183Cv3zyoL.jpg",
  #               "smallImage": "http://ecx.images-amazon.com/images/I/5183Cv3zyoL._SR38,50_.jpg"
  #             }
  #           },
  #           "similar_products": [{
  #             "title": "I sleep with a Beagle Women Sweatshirt",
  #             "asin": "B017TGCK7I"
  #           }, {
  #             "title": "All I do is win squash Women Sweatshirt",
  #             "asin": "B017TGCCCQ"
  #           }, {
  #             "title": "Wrestling I will break you Women Sweatshirt",
  #             "asin": "B017TGC0EG"
  #           }, {
  #             "title": "I\'m drunk and you\'re still ugly Women Sweatshirt",
  #             "asin": "B017TGC01O"
  #           }, {
  #             "title": "Drunk and sexy Women Sweatshirt",
  #             "asin": "B017TGB8EY"
  #           }, {
  #             "title": "I play squash therefore I am awesome Women Sweatshirt",
  #             "asin": "B017TGB57E"
  #           }, {
  #             "title": "Hug me Pug Women Sweatshirt",
  #             "asin": "B017TGDA2M"
  #           }, {
  #             "title": "Labrador Retriever sorry Women Sweatshirt",
  #             "asin": "B017TGCEOC"
  #           }, {
  #             "title": "Best friend Pug Women Sweatshirt",
  #             "asin": "B017TGD2KW"
  #           }, {
  #             "title": "Leave me alone I\'m only talking to my Great Dane Women Sweatshirt",
  #             "asin": "B017TGDLTY"
  #           }, {
  #             "title": "The secret to excellence in Akita agility Women Sweatshirt",
  #             "asin": "B017TGCRZ8"
  #           }, {
  #             "title": "Stop do not open this door! Women Sweatshirt",
  #             "asin": "B017TGDEO6"
  #           }]
  #         }
  #       }]
  #     }
  #   }'
  #   @json = ActiveSupport::JSON.decode(json)
  #   create(:variant_store, sku: 'B017TGCK7I', variant: create(:variant))

  #   task = AddProductsFromPromptcloudJson.new(@json)
  #   expect{ task.call }.to change(Product, :count).by(1)
  #   expect{ task.call }.to change(Product, :count).by(0) #second call find by product_code
  #   test_product = Product.last
  #   expect(test_product.name).to eq 'I ONLY CARE ABOUT 2 THINGS SEX AND Nordic Skiing Women Hoodie'
  #   expect(test_product.product_code).to eq 'f5b532663251669a1f53482b1f728a77'

  #   expect(Variant.count).to eq(8) #exist one to find product similarity
  #   expect(OptionValue.count).to eq(7)
  #   expect(ProductOptionType.count).to eq(1)
  #   expect(OptionValueVariant.count).to eq(7)

  #   expect(VariantStore.count).to eq(8) #exist one to find product similarity
  #   test_store = VariantStore.last
  #   expect(test_store.url).to eq 'http://www.amazon.com/ABOUT-THINGS-Nordic-Skiing-Hoodie/dp/B00PVBWLZU'
  #   expect(test_store.price).to eq nil
  #   expect(test_product.price_range).to eq "$19.99 - $39.99"
  #   expect(test_store.currency).to eq 'USD'
  #   expect(test_store.sku).to eq 'B00PVBWLZU'

  #   expect(ProductFile.count).to eq(1)
  #   test_product_file = ProductFile.last
  #   expect(test_product_file.small_version_url).to eq 'http://ecx.images-amazon.com/images/I/5183Cv3zyoL._SR38,50_.jpg'
  #   expect(test_product_file.normal_version_url).to eq 'http://ecx.images-amazon.com/images/I/5183Cv3zyoL.jpg'
  #   expect(test_product_file.large_version_url).to eq 'http://ecx.images-amazon.com/images/I/71gfvFxQLlL._UL1500_.jpg'

  #   #product_similarity
  #   expect(ProductSimilarity.count).to eq(2)
  # end

  # it 'json with only color variants' do
  #   json = '{
  #     "root": {
  #       "page": [{
  #         "pageurl":"http://www.amazon.com/Prego-Italian-23-5oz-Roasted-Parmesan/dp/B00FP6WAQQ",
  #         "record":{
  #         "uniq_id":"c6a1bf4d95caee10b541fe3f417e0785",
  #         "detail_pageurl":"http://www.amazon.com/Prego-Italian-23-5oz-Roasted-Parmesan/dp/B00FP6WAQQ",
  #         "title":"Prego Italian Pasta Sauce 23.5oz Jar (Pack of 4) Choose Flavor Below (Roasted Garlic Parmesan)",
  #         "innermost_category":"Hot Sauce",
  #         "department":"Hot Sauce",
  #         "product_name":"Prego Italian Pasta Sauce 23.5oz Jar (Pack of 4) Choose Flavor Below (Roasted Garlic Parmesan)",
  #         "asin":"B00FP6WAQQ",
  #         "item_base_price":"$9.95",
  #         "category_hierarchy": ["Clothing, Shoes & Jewelry", "Novelty & More", "Clothing", "Novelty", "Women", "Hoodies"],
  #         "available_colors":{
  #           "color_0":"CreamyVodka",
  #           "color_1":"Bacon&Provolone",
  #           "color_2":"ItalianSausage&Garlic",
  #           "color_3":"Fontina&AsiagoCheese",
  #           "color_4":"Traditional",
  #           "color_5":"Arrabbiata",
  #           "color_6":"Mini-Meatball",
  #           "color_7":"RoastedGarlicParmesan",
  #           "color_8":"SpicySausage"
  #         },
  #         "images":{
  #           "default_image_links":{
  #             "mediumImage":"http://ecx.images-amazon.com/images/I/41enyQwxDZL.jpg",
  #             "smallImage":"http://ecx.images-amazon.com/images/I/41enyQwxDZL._SS40_.jpg"
  #           },
  #         "color_image_variants":{
  #           "color_0":{
  #           "mediumImage":"http://ecx.images-amazon.com/images/I/31x-FfBEAVL.jpg",
  #           "smallImage":"http://ecx.images-amazon.com/images/I/31x-FfBEAVL._SS40_.jpg"
  #           },
  #           "color_1":{
  #           "largeImage":"http://ecx.images-amazon.com/images/I/61ZVtY522zL._SL1024_.jpg",
  #           "mediumImage":"http://ecx.images-amazon.com/images/I/41Q%2BPPgjc1L.jpg",
  #           "smallImage":"http://ecx.images-amazon.com/images/I/41Q%2BPPgjc1L._SS40_.jpg"
  #           },
  #           "color_2":{
  #           "mediumImage":"http://ecx.images-amazon.com/images/I/31VZgc7WIBL.jpg",
  #           "smallImage":"http://ecx.images-amazon.com/images/I/31VZgc7WIBL._SS40_.jpg"
  #           },
  #           "color_3":{
  #           "mediumImage":"http://ecx.images-amazon.com/images/I/31cq2Jnrf2L.jpg",
  #           "smallImage":"http://ecx.images-amazon.com/images/I/31cq2Jnrf2L._SS40_.jpg"
  #           },
  #           "color_4":{
  #           "mediumImage":"http://ecx.images-amazon.com/images/I/41ZlSP3CczL.jpg",
  #           "smallImage":"http://ecx.images-amazon.com/images/I/41ZlSP3CczL._SS40_.jpg"
  #           },
  #           "color_5":{
  #           "mediumImage":"http://ecx.images-amazon.com/images/I/31gDNuvfykL.jpg",
  #           "smallImage":"http://ecx.images-amazon.com/images/I/31gDNuvfykL._SS40_.jpg"
  #           },
  #           "color_6":{
  #           "mediumImage":"http://ecx.images-amazon.com/images/I/51jsYMqkR2L.jpg",
  #           "smallImage":"http://ecx.images-amazon.com/images/I/51jsYMqkR2L._SS40_.jpg"
  #           },
  #           "color_7":{
  #           "mediumImage":"http://ecx.images-amazon.com/images/I/41enyQwxDZL.jpg",
  #           "smallImage":"http://ecx.images-amazon.com/images/I/41enyQwxDZL._SS40_.jpg"
  #           },
  #           "color_8":{
  #           "mediumImage":"http://ecx.images-amazon.com/images/I/31RV4a8E9ZL.jpg",
  #           "smallImage":"http://ecx.images-amazon.com/images/I/31RV4a8E9ZL._SS40_.jpg"
  #           }
  #         }
  #         },
  #         "similar_products":[
  #         {
  #         "title":"Barilla Spaghetti, 16 Ounce (Pack of 8)",
  #         "asin":"B00WBGKJPW"
  #         },
  #         {
  #         "title":"Barilla Pasta Sauce Variety Pack, 24 Ounce, 4 Jars",
  #         "asin":"B00FQGP20Q"
  #         },
  #         {
  #         "title":"Prego Creamy Vodka Italian Sauce, 24 oz",
  #         "asin":"B00MYII59O"
  #         },
  #         {
  #         "title":"Prego Sauce Spicy Sausage",
  #         "asin":"B00RD8T5XU"
  #         },
  #         {
  #         "title":"Prego Regular Spaghetti Sauce - 3 pk",
  #         "asin":"B00N7JGS3E"
  #         },
  #         {
  #         "title":"Mom\'s Pasta Sauce, Garlic & Basil, 14 Ounce (Pack of 6)",
  #         "asin":"B001HTKUSU"
  #         }
  #         ]
  #         }
  #         }]
  #     }
  #   }'
  #   @json = ActiveSupport::JSON.decode(json)

  #   task = AddProductsFromPromptcloudJson.new(@json)
  #   expect{ task.call }.to change(Product, :count).by(1)
  #   expect{ task.call }.to change(Product, :count).by(0) #second call find by product_code
  #   test_product = Product.last
  #   expect(test_product.name).to eq 'Prego Italian Pasta Sauce 23.5oz Jar (Pack of 4) Choose Flavor Below (Roasted Garlic Parmesan)'
  #   expect(test_product.product_code).to eq 'c6a1bf4d95caee10b541fe3f417e0785'

  #   expect(Variant.count).to eq(9)
  #   expect(OptionValue.count).to eq(9)
  #   expect(ProductOptionType.count).to eq(1)
  #   expect(OptionValueVariant.count).to eq(9)

  #   expect(VariantStore.count).to eq(9) #exist one to find product similarity
  #   test_store = VariantStore.last
  #   expect(test_store.url).to eq 'http://www.amazon.com/Prego-Italian-23-5oz-Roasted-Parmesan/dp/B00FP6WAQQ'
  #   expect(test_store.price.to_f).to eq 9.95
  #   expect(test_product.price_range).to eq "$9.95"
  #   expect(test_store.currency).to eq 'USD'
  #   expect(test_store.sku).to eq 'B00FP6WAQQ'

  #   expect(VariantFile.count).to eq(9)
  #   test_variant_file = VariantFile.last
  #   expect(test_variant_file.small_version_url).to eq 'http://ecx.images-amazon.com/images/I/31RV4a8E9ZL._SS40_.jpg'
  #   expect(test_variant_file.normal_version_url).to eq 'http://ecx.images-amazon.com/images/I/31RV4a8E9ZL.jpg'
  #   expect(test_variant_file.large_version_url).to eq ''

  #   #product_similarity
  #   expect(ProductSimilarity.count).to eq(0)
  # end

  # it 'json with size and color variants' do
  #   json = '{
  #     "root": {
  #       "page": [{
  #         "pageurl": "http://www.amazon.com/Rudy-Oops-Missy-Bottom-Sweatpant/dp/B019KZDRJ6",
  #         "record": {
  #           "uniq_id": "9eb90e105ba8d51f4451c61495bc6222",
  #           "detail_pageurl": "http://www.amazon.com/Rudy-Oops-Missy-Bottom-Sweatpant/dp/B019KZDRJ6",
  #           "title": "A PRODUCT WITH VARIANT IMAGES",
  #           "innermost_category": "Pants & Capris",
  #           "department": "Pants & Capris",
  #           "product_name": "Rudy Oops By Jay Missy Fit Open Bottom Sweatpant",
  #           "asin": "B019KZDRJ6",
  #           "item_base_price": "$22.99 - $35.99",
  #           "category_hierarchy": ["Clothing, Shoes & Jewelry", "Novelty & More", "Clothing", "Novelty", "Women", "Hoodies"],
  #           "available_sizes": {
  #             "size_0": "Small",
  #             "size_1": "Medium",
  #             "size_2": "Large",
  #             "size_3": "X-Large",
  #             "size_4": "XX-Large"
  #           },
  #           "available_colors": {
  #             "color_0": "SportsGrey",
  #             "color_1": "Charcoal",
  #             "color_2": "Black",
  #             "color_3": "Navy"
  #           },
  #           "available_features": {
  #             "feature_0": "8.0 oz., pre-shrunk 50/50 cotton/polyester, Covered elastic waistband with flat drawcord, Differential rise",
  #             "feature_1": "Outstanding Fabric Quality!",
  #             "feature_2": "Super Fast Shipping! & 100% Money Back Guarantee. Actual Colors Or Images May Vary Slightly From Picture",
  #             "feature_3": "Our designs are available on a wide range of apparel; t-shirts, hoodies, sweatshirts, workout tank tops, maternity shirts, baby onesies and more. Visit our store for more great items.",
  #             "feature_4": "This is not an unauthorized replica/counterfeit item. This is an original inspired design and does not infringe on any rights holders rights. Words used in the title/search terms are not intended to imply they are licensed by any rights holders."
  #           },
  #           "images": {
  #             "default_image_links": [{
  #               "largeImage": "http://ecx.images-amazon.com/images/I/51Kl2VufhtL._UL1500_.jpg",
  #               "mediumImage": "http://ecx.images-amazon.com/images/I/31ON35cK1xL.jpg",
  #               "smallImage": "http://ecx.images-amazon.com/images/I/31ON35cK1xL._SR38,50_.jpg"
  #             }, {
  #               "largeImage": "http://ecx.images-amazon.com/images/I/61SDR3uhpDL._UL1500_.jpg",
  #               "mediumImage": "http://ecx.images-amazon.com/images/I/41%2Bt4pY-QiL.jpg",
  #               "smallImage": "http://ecx.images-amazon.com/images/I/41%2Bt4pY-QiL._SR38,50_.jpg"
  #             }, {
  #               "largeImage": "http://ecx.images-amazon.com/images/I/71OJFR4B7rL._UL1500_.jpg",
  #               "mediumImage": "http://ecx.images-amazon.com/images/I/51w1vvAK3WL.jpg",
  #               "smallImage": "http://ecx.images-amazon.com/images/I/51w1vvAK3WL._SR38,50_.jpg"
  #             }],
  #             "color_image_variants": {
  #               "color_0": [{
  #                 "largeImage": "http://ecx.images-amazon.com/images/I/61IDOHDJIVL._UL1200_.jpg",
  #                 "mediumImage": "http://ecx.images-amazon.com/images/I/41DRetXoNyL.jpg",
  #                 "smallImage": "http://ecx.images-amazon.com/images/I/41DRetXoNyL._SR38,50_.jpg"
  #               }, {
  #                 "largeImage": "http://ecx.images-amazon.com/images/I/61SDR3uhpDL._UL1200_.jpg",
  #                 "mediumImage": "http://ecx.images-amazon.com/images/I/41%2Bt4pY-QiL.jpg",
  #                 "smallImage": "http://ecx.images-amazon.com/images/I/41%2Bt4pY-QiL._SR38,50_.jpg"
  #               }, {
  #                 "largeImage": "http://ecx.images-amazon.com/images/I/71OJFR4B7rL._UL1300_.jpg",
  #                 "mediumImage": "http://ecx.images-amazon.com/images/I/51w1vvAK3WL.jpg",
  #                 "smallImage": "http://ecx.images-amazon.com/images/I/51w1vvAK3WL._SR38,50_.jpg"
  #               }],
  #               "color_1": [{
  #                 "largeImage": "http://ecx.images-amazon.com/images/I/514aaCg%2BrqL._UL1200_.jpg",
  #                 "mediumImage": "http://ecx.images-amazon.com/images/I/313Fze9giML.jpg",
  #                 "smallImage": "http://ecx.images-amazon.com/images/I/313Fze9giML._SR38,50_.jpg"
  #               }, {
  #                 "largeImage": "http://ecx.images-amazon.com/images/I/61SDR3uhpDL._UL1200_.jpg",
  #                 "mediumImage": "http://ecx.images-amazon.com/images/I/41%2Bt4pY-QiL.jpg",
  #                 "smallImage": "http://ecx.images-amazon.com/images/I/41%2Bt4pY-QiL._SR38,50_.jpg"
  #               }, {
  #                 "largeImage": "http://ecx.images-amazon.com/images/I/71OJFR4B7rL._UL1300_.jpg",
  #                 "mediumImage": "http://ecx.images-amazon.com/images/I/51w1vvAK3WL.jpg",
  #                 "smallImage": "http://ecx.images-amazon.com/images/I/51w1vvAK3WL._SR38,50_.jpg"
  #               }],
  #               "color_2": [{
  #                 "largeImage": "http://ecx.images-amazon.com/images/I/51Kl2VufhtL._UL1200_.jpg",
  #                 "mediumImage": "http://ecx.images-amazon.com/images/I/31ON35cK1xL.jpg",
  #                 "smallImage": "http://ecx.images-amazon.com/images/I/31ON35cK1xL._SR38,50_.jpg"
  #               }, {
  #                 "largeImage": "http://ecx.images-amazon.com/images/I/61SDR3uhpDL._UL1200_.jpg",
  #                 "mediumImage": "http://ecx.images-amazon.com/images/I/41%2Bt4pY-QiL.jpg",
  #                 "smallImage": "http://ecx.images-amazon.com/images/I/41%2Bt4pY-QiL._SR38,50_.jpg"
  #               }, {
  #                 "largeImage": "http://ecx.images-amazon.com/images/I/71OJFR4B7rL._UL1300_.jpg",
  #                 "mediumImage": "http://ecx.images-amazon.com/images/I/51w1vvAK3WL.jpg",
  #                 "smallImage": "http://ecx.images-amazon.com/images/I/51w1vvAK3WL._SR38,50_.jpg"
  #               }],
  #               "color_3": [{
  #                 "largeImage": "http://ecx.images-amazon.com/images/I/515NF1diXbL._UL1200_.jpg",
  #                 "mediumImage": "http://ecx.images-amazon.com/images/I/31vRTUKjwgL.jpg",
  #                 "smallImage": "http://ecx.images-amazon.com/images/I/31vRTUKjwgL._SR38,50_.jpg"
  #               }, {
  #                 "largeImage": "http://ecx.images-amazon.com/images/I/61SDR3uhpDL._UL1200_.jpg",
  #                 "mediumImage": "http://ecx.images-amazon.com/images/I/41%2Bt4pY-QiL.jpg",
  #                 "smallImage": "http://ecx.images-amazon.com/images/I/41%2Bt4pY-QiL._SR38,50_.jpg"
  #               }, {
  #                 "largeImage": "http://ecx.images-amazon.com/images/I/71OJFR4B7rL._UL1300_.jpg",
  #                 "mediumImage": "http://ecx.images-amazon.com/images/I/51w1vvAK3WL.jpg",
  #                 "smallImage": "http://ecx.images-amazon.com/images/I/51w1vvAK3WL._SR38,50_.jpg"
  #               }]
  #             }
  #           },
  #           "similar_products": [{
  #             "title": "New Years Missy Fit Open Bottom Sweatpant",
  #             "asin": "B019LFDH9K"
  #           }, {
  #             "title": "Fireworks Missy Fit Open Bottom Sweatpant",
  #             "asin": "B019LEKD1G"
  #           }, {
  #             "title": "Red Fireworks Missy Fit Open Bottom Sweatpant",
  #             "asin": "B019LEIDL8"
  #           }, {
  #             "title": "Santa Claus15 Missy Fit Open Bottom Sweatpant",
  #             "asin": "B019LDD7P6"
  #           }, {
  #             "title": "Ho Ho Ho 15 Missy Fit Open Bottom Sweatpant",
  #             "asin": "B019LD7TVE"
  #           }, {
  #             "title": "Lumberjack Xmas Missy Fit Open Bottom Sweatpant",
  #             "asin": "B019LDGZVY"
  #           }, {
  #             "title": "Happy New Year 22 Missy Fit Open Bottom Sweatpant",
  #             "asin": "B019LEANQ6"
  #           }, {
  #             "title": "Happy New Year 20 Missy Fit Open Bottom Sweatpant",
  #             "asin": "B019LEC0ZI"
  #           }, {
  #             "title": "Happy New Year 17 Missy Fit Open Bottom Sweatpant",
  #             "asin": "B019LE71FC"
  #           }, {
  #             "title": "Happy New Year 27 Missy Fit Open Bottom Sweatpant",
  #             "asin": "B019LE99EI"
  #           }, {
  #             "title": "Happy New Year 14 Missy Fit Open Bottom Sweatpant",
  #             "asin": "B019LE8KDE"
  #           }, {
  #             "title": "Happy New Year 15 Missy Fit Open Bottom Sweatpant",
  #             "asin": "B019LE5LBS"
  #           }]
  #         }
  #       }]
  #     }
  #   }'

  #   @json = ActiveSupport::JSON.decode(json)

  #   task = AddProductsFromPromptcloudJson.new(@json)
  #   expect{ task.call }.to change(Product, :count).by(1)

  #   expect{ task.call }.to change(Product, :count).by(0) #second call find by product_code
  #   test_product = Product.last
  #   expect(test_product.name).to eq 'Rudy Oops By Jay Missy Fit Open Bottom Sweatpant'
  #   expect(test_product.product_code).to eq '9eb90e105ba8d51f4451c61495bc6222'
  #   expect(test_product.category_hierarchy).to eq ["Clothing, Shoes & Jewelry", "Novelty & More", "Clothing", "Novelty", "Women", "Hoodies"]

  #   expect(Variant.count).to eq(20)
  #   expect(OptionValue.count).to eq(9)
  #   expect(ProductOptionType.count).to eq(2)
  #   expect(OptionValueVariant.count).to eq(40)

  #   expect(VariantStore.count).to eq(20)
  #   test_store = VariantStore.last
  #   expect(test_store.url).to eq 'http://www.amazon.com/Rudy-Oops-Missy-Bottom-Sweatpant/dp/B019KZDRJ6'
  #   expect(test_store.price).to eq nil
  #   expect(test_product.price_range).to eq "$22.99 - $35.99"
  #   expect(test_store.currency).to eq 'USD'
  #   expect(test_store.sku).to eq 'B019KZDRJ6'

  #   expect(VariantFile.count).to eq(60) #3 for product and 3 for all variants
  #   test_variant_file = VariantFile.last #product
  #   expect(test_variant_file.small_version_url).to eq 'http://ecx.images-amazon.com/images/I/51w1vvAK3WL._SR38,50_.jpg'
  #   expect(test_variant_file.normal_version_url).to eq 'http://ecx.images-amazon.com/images/I/51w1vvAK3WL.jpg'
  #   expect(test_variant_file.large_version_url).to eq 'http://ecx.images-amazon.com/images/I/71OJFR4B7rL._UL1300_.jpg'

  #   #similar_tests
  # end
end
