class CreateCategories
  def call
    Category.delete_all

    Category.create(id: 40, name: "Woman")
    Category.create(id: 1, name: "Dresses", parent_id: 40)
    Category.create(id: 2, name: "Tops & Tees", parent_id: 40)
    Category.create(id: 3, name: "Sweaters", parent_id: 40)
    Category.create(id: 4, name: "Hoodies & Sweatshirts", parent_id: 40)
    Category.create(id: 5, name: "Jeans", parent_id: 40)
    Category.create(id: 6, name: "Pants", parent_id: 40)
    Category.create(id: 7, name: "Skirts", parent_id: 40)
    Category.create(id: 8, name: "Shorts", parent_id: 40)
    Category.create(id: 9, name: "Leggings", parent_id: 40)
    Category.create(id: 10, name: "Swimsuits & Cover Ups", parent_id: 40)
    Category.create(id: 11, name: "Lingerie, Sleep & Lounge", parent_id: 40)
    Category.create(id: 12, name: "Jumpsuits, Rompers & Overalls", parent_id: 40)
    Category.create(id: 13, name: "Coats, Jackets & Vests", parent_id: 40)
    Category.create(id: 14, name: "Suiting & Blazers", parent_id: 40)
    Category.create(id: 15, name: "Socks & Hosiery", parent_id: 40)
    Category.create(id: 16, name: "Shoes", parent_id: 40)
    Category.create(id: 17, name: "Jewelry", parent_id: 40)
    Category.create(id: 18, name: "Watches", parent_id: 40)
    Category.create(id: 19, name: "Bags & Wallets", parent_id: 40)
    Category.create(id: 20, name: "Belts", parent_id: 40)
    Category.create(id: 38, name: "Sunglasses", parent_id: 40)
    Category.create(id: 39, name: "Accessories", parent_id: 40)
    Category.create(id: 41, name: "Man")
    Category.create(id: 21, name: "Shirts", parent_id: 41)
    Category.create(id: 22, name: "Hoodies & Sweatshirts", parent_id: 41)
    Category.create(id: 23, name: "Sweaters", parent_id: 41)
    Category.create(id: 24, name: "Jackets & Coats", parent_id: 41)
    Category.create(id: 25, name: "Jeans", parent_id: 41)
    Category.create(id: 26, name: "Pants", parent_id: 41)
    Category.create(id: 27, name: "Shorts", parent_id: 41)
    Category.create(id: 28, name: "Swim", parent_id: 41)
    Category.create(id: 29, name: "Suits & Sport Coats", parent_id: 41)
    Category.create(id: 30, name: "Underwear", parent_id: 41)
    Category.create(id: 31, name: "Socks", parent_id: 41)
    Category.create(id: 32, name: "Shoes", parent_id: 41)
    Category.create(id: 33, name: "Jewelry", parent_id: 41)
    Category.create(id: 34, name: "Watches", parent_id: 41)
    Category.create(id: 35, name: "Accessories", parent_id: 41)
    Category.create(id: 36, name: "Sunglasses", parent_id: 41)
    Category.create(id: 37, name: "Belts", parent_id: 41)
  end
end
