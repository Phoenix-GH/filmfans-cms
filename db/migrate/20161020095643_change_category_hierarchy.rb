class ChangeCategoryHierarchy < ActiveRecord::Migration
  def change
    execute <<-SQL
      -- Man
      -- Move T-Shirts and Tank-tops to Shirts
      -- t-shirt
      update categories set parent_id = 51 where id = 121;
      delete from categories where id = 65;
      -- tank top
      update categories set parent_id = 51 where id = 122;
      delete from categories where id = 66;

      -- Create Trousers as a main category and put Jeans, Pants, Shorts, Swimwear under it
      INSERT INTO categories
      (id,  name,          parent_id,  display_name,        imaging_category, level, unisex, size_required, hidden, created_at, updated_at) VALUES
      (217, 'Trousers',    41,          'Man > Trousers',   NULL,             2,     false,  true,        false,     now(), now());
      -- Jeans
      update categories set parent_id = 217 where id = 112;
      delete from categories where id = 61;
      -- Pants
      update categories set parent_id = 217 where id = 113;
      delete from categories where id = 62;
      -- Shorts
      update categories set parent_id = 217 where id = 119;
      delete from categories where id = 63;
      -- Swimwear
      update categories set parent_id = 217 where id = 98;
      delete from categories where id = 56;

      -- Move Ties, Underwear as part of accessories
      -- Ties
      update categories set parent_id = 59 where id = 171;
      delete from categories where id = 169;
      -- Underwear
      update categories set parent_id = 59 where id = 99;
      delete from categories where id = 57;

      -- Create Suits, Coats and Sweaters as a main category
      -- and put Suits, Blazers & Sport Coats, Cardigans, Sweaters and Sweatshirts, Hoodies, Jackets into it
      INSERT INTO categories
      (id,  name,          parent_id,  display_name,        imaging_category, level, unisex, size_required, hidden, created_at, updated_at) VALUES
      (218, 'Suits, Coats & Sweaters',    41,          'Man > Suits, Coats & Sweaters',   NULL,             2,     false,  true,        false,     now(), now());
      -- Suits
      update categories set parent_id = 218 where id = 95;
      delete from categories where id = 53;
      -- Blazers & Sport Coats
      update categories set parent_id = 218 where id = 89;
      delete from categories where id = 50;
      -- Cardigans
      update categories set parent_id = 218 where id = 187;
      delete from categories where id = 179;
      -- Sweaters
      update categories set parent_id = 218 where id = 96;
      delete from categories where id = 54;
      -- Sweatshirts
      update categories set parent_id = 218 where id = 97;
      delete from categories where id = 55;
      -- Hoodies
      update categories set parent_id = 218 where id = 111;
      delete from categories where id = 60;
      -- Jackets
      update categories set parent_id = 218 where id = 164;
      delete from categories where id = 163;

      -- Woman
      -- Create Tops & Tees as a main category and put blouses, crop tops, tops, T-shirts in it
      INSERT INTO categories
      (id,  name,                   parent_id,  display_name,               imaging_category, level, unisex, size_required, hidden, created_at, updated_at) VALUES
      (219, 'Create Tops & Tees',    40,        'Man > Create Tops & Tees',  NULL,             2,     false,  true,        false,     now(), now());
      -- Blouses
      update categories set parent_id = 219 where id = 172;
      delete from categories where id = 170;
      -- Crop tops
      update categories set parent_id = 219 where id = 174;
      delete from categories where id = 173;
      -- Tops
      update categories set parent_id = 219 where id = 144;
      delete from categories where id = 75;
      -- T-shirts
      update categories set parent_id = 219 where id = 143;
      delete from categories where id = 74;

      -- Create Suits, Coats and Sweaters as a main category
      -- and put Blazers & Sport Coats, Capes, Cardigans, Hoodies, Jackers, Sweaters, Sweatshirts, Vests
      INSERT INTO categories
      (id,  name,                   parent_id,  display_name,               imaging_category, level, unisex, size_required, hidden, created_at, updated_at) VALUES
      (220, 'Suits, Coats & Sweaters',    40,   'Man > Suits, Coats & Sweaters',  NULL,       2,     false,  true,          false,     now(), now());
      -- Blazers & Sport Coats
      update categories set parent_id = 220 where id = 145;
      delete from categories where id = 76;
      -- Capes
      update categories set parent_id = 220 where id = 199;
      delete from categories where id = 200;
      -- Cardigans
      update categories set parent_id = 220 where id = 186;
      delete from categories where id = 178;
      -- Hoodies
      update categories set parent_id = 220 where id = 133;
      delete from categories where id = 68;
      -- Jackets
      update categories set parent_id = 220 where id = 166;
      delete from categories where id = 165;
      -- Sweaters
      update categories set parent_id = 220 where id = 158;
      delete from categories where id = 84;
      -- Sweatshirts
      update categories set parent_id = 220 where id = 159;
      delete from categories where id = 85;
      -- Vests
      update categories set parent_id = 220 where id = 168;
      delete from categories where id = 167;

      -- Move Earrings, Leggings, into accessories
      -- Earrings
      update categories set parent_id = 67 where id = 149;
      delete from categories where id = 78;
      -- Leggings
      update categories set parent_id = 67 where id = 151;
      delete from categories where id = 80;

      -- Create Lingerie as a main category and put underwear, bodysuits
      -- Bodysuits
      update categories set parent_id = 87 where id = 195;
      delete from categories where id = 180;

      -- Create Pants & Skirts as a main category and put Pants, Jumpsuits, Shorts, Skirts into it
      INSERT INTO categories
      (id,  name,              parent_id,  display_name,            imaging_category, level, unisex, size_required, hidden, created_at, updated_at) VALUES
      (221, 'Pants & Skirts',  40,         'Man > Pants & Skirts',  NULL,             2,     false,  true,          false,     now(), now());
      -- Pants
      update categories set parent_id = 221 where id = 135;
      delete from categories where id = 70;
      -- Jumpsuits
      update categories set parent_id = 221 where id = 150;
      delete from categories where id = 79;
      -- Shorts
      update categories set parent_id = 221 where id = 141;
      delete from categories where id = 72;
      -- Skirts
      update categories set parent_id = 221 where id = 157;
      delete from categories where id = 83;
    SQL
  end
end
