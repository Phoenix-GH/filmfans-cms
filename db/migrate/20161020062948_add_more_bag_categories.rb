class AddMoreBagCategories < ActiveRecord::Migration
  def change
    execute <<-SQL
      INSERT INTO categories
      (id,  name,          parent_id,  display_name,                imaging_category, level, unisex, size_required, hidden, created_at, updated_at) VALUES
      (207, 'Briefcases',  177,      'Man > Bags > Briefcases',     NULL,             3,      false,  false,        true,     now(), now()),
      (208, 'Duffle Bags', 177,      'Man > Bags > Duffle Bags',    NULL,             3,      true,   false,        true,     now(), now()),
      (209, 'Card holders', 177,     'Man > Bags > Card holders',   NULL,             3,      true,   false,        true,     now(), now()),
      (210, 'Phone cases', 177,      'Man > Bags > Phone cases',    NULL,             3,      true,   false,        true,     now(), now()),
      (211, 'Passport holders', 177, 'Man > Bags > Passport holders', NULL,           3,      true,   false,        true,     now(), now()),

      (212, 'Duffle Bags', 82,       'Woman > Bags > Duffle Bags',  NULL,             3,      true,   false,        true,     now(), now()),
      (213, 'Card holders', 82,      'Woman > Bags > Card holders', NULL,             3,      true,   false,        true,     now(), now()),
      (214, 'Phone cases', 82,       'Woman > Bags > Phone cases',  NULL,             3,      true,   false,        true,     now(), now()),
      (215, 'Passport holders', 82,  'Woman > Bags > Passport holders', NULL,         3,      true,   false,        true,     now(), now()),

      (216, 'Sandal Stilettos', 71,  'Woman > Shoes > Sandal Stilettos', NULL,        3,      false,   true,        true,     now(), now());
    SQL
  end
end
