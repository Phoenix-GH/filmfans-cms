class AddBeautyCategories < ActiveRecord::Migration
  def change
      execute <<-SQL
        INSERT INTO categories
          (id,  name,  parent_id,  display_name, imaging_category, level, unisex, size_required, hidden, created_at, updated_at) VALUES
          (250, 'Beauty', NULL, 'Beauty', NULL, 1,false,false,true,now(), now()) ,
          (251, 'Women', 250, 'Beauty > Women', NULL, 2,false,false,true,now(), now()) ,
          (252, 'Bath & Body', 251, 'Beauty > Women > Bath & Body', NULL, 3,false,false,true,now(), now()) ,
          (253, 'Aromatherapy', 252, 'Beauty > Women > Bath & Body > Aromatherapy', NULL, 4,false,false,true,now(), now()) ,
          (254, 'Candles', 253, 'Beauty > Women > Bath & Body > Aromatherapy > Candles', NULL, 5,false,false,true,now(), now()) ,
          (255, 'Diffusers', 253, 'Beauty > Women > Bath & Body > Aromatherapy > Diffusers', NULL, 5,false,false,true,now(), now()) ,
          (256, 'Essential Oil', 253, 'Beauty > Women > Bath & Body > Aromatherapy > Essential Oil', NULL, 5,false,false,true,now(), now()) ,
          (257, 'Room Spray', 253, 'Beauty > Women > Bath & Body > Aromatherapy > Room Spray', NULL, 5,false,false,true,now(), now()) ,
          (258, 'Body Wash', 252, 'Beauty > Women > Bath & Body > Body Wash', NULL, 4,false,false,true,now(), now()) ,
          (259, 'Bath Salts', 258, 'Beauty > Women > Bath & Body > Body Wash > Bath Salts', NULL, 5,false,false,true,now(), now()) ,
          (260, 'Bubble Bath', 258, 'Beauty > Women > Bath & Body > Body Wash > Bubble Bath', NULL, 5,false,false,true,now(), now()) ,
          (261, 'Exfoliator', 258, 'Beauty > Women > Bath & Body > Body Wash > Exfoliator', NULL, 5,false,false,true,now(), now()) ,
          (262, 'Soap', 258, 'Beauty > Women > Bath & Body > Body Wash > Soap', NULL, 5,false,false,true,now(), now()) ,
          (263, 'Enhancers & Treatments', 252, 'Beauty > Women > Bath & Body > Enhancers & Treatments', NULL, 4,false,false,true,now(), now()) ,
          (264, 'Cellulite & Stretch Marks', 263, 'Beauty > Women > Bath & Body > Enhancers & Treatments > Cellulite & Stretch Marks', NULL, 5,false,false,true,now(), now()) ,
          (265, 'Legs', 263, 'Beauty > Women > Bath & Body > Enhancers & Treatments > Legs', NULL, 5,false,false,true,now(), now()) ,
          (266, 'Sports', 263, 'Beauty > Women > Bath & Body > Enhancers & Treatments > Sports', NULL, 5,false,false,true,now(), now()) ,
          (267, 'Fragrances', 252, 'Beauty > Women > Bath & Body > Fragrances', NULL, 4,false,false,true,now(), now()) ,
          (268, 'Eau de Perfumes', 267, 'Beauty > Women > Bath & Body > Fragrances > Eau de Perfumes', NULL, 5,false,false,true,now(), now()) ,
          (269, 'Eau de Toilettes', 267, 'Beauty > Women > Bath & Body > Fragrances > Eau de Toilettes', NULL, 5,false,false,true,now(), now()) ,
          (270, 'Solid Fragrances', 267, 'Beauty > Women > Bath & Body > Fragrances > Solid Fragrances', NULL, 5,false,false,true,now(), now()) ,
          (271, 'Manicure & Pedicure', 252, 'Beauty > Women > Bath & Body > Manicure & Pedicure', NULL, 4,false,false,true,now(), now()) ,
          (272, 'Foot Treatments', 271, 'Beauty > Women > Bath & Body > Manicure & Pedicure > Foot Treatments', NULL, 5,false,false,true,now(), now()) ,
          (273, 'Hand Lotion & Cream', 271, 'Beauty > Women > Bath & Body > Manicure & Pedicure > Hand Lotion & Cream', NULL, 5,false,false,true,now(), now()) ,
          (274, 'Hand Wash', 271, 'Beauty > Women > Bath & Body > Manicure & Pedicure > Hand Wash', NULL, 5,false,false,true,now(), now()) ,
          (275, 'Small Tools', 271, 'Beauty > Women > Bath & Body > Manicure & Pedicure > Small Tools', NULL, 5,false,false,true,now(), now()) ,
          (276, 'Moisturiser', 252, 'Beauty > Women > Bath & Body > Moisturiser', NULL, 4,false,false,true,now(), now()) ,
          (277, 'Cream', 276, 'Beauty > Women > Bath & Body > Moisturiser > Cream', NULL, 5,false,false,true,now(), now()) ,
          (278, 'Lotion', 276, 'Beauty > Women > Bath & Body > Moisturiser > Lotion', NULL, 5,false,false,true,now(), now()) ,
          (279, 'Oil', 276, 'Beauty > Women > Bath & Body > Moisturiser > Oil', NULL, 5,false,false,true,now(), now()) ,
          (280, 'Suncare', 252, 'Beauty > Women > Bath & Body > Suncare', NULL, 4,false,false,true,now(), now()) ,
          (281, 'Self Tanning', 280, 'Beauty > Women > Bath & Body > Suncare > Self Tanning', NULL, 5,false,false,true,now(), now()) ,
          (282, 'Sun Protection', 280, 'Beauty > Women > Bath & Body > Suncare > Sun Protection', NULL, 5,false,false,true,now(), now()) ,
          (283, 'Hair', 251, 'Beauty > Women > Hair', NULL, 3,false,false,true,now(), now()) ,
          (284, 'Dry Shampoo', 283, 'Beauty > Women > Hair > Dry Shampoo', NULL, 4,false,false,true,now(), now()) ,
          (285, 'Shampoo & Conditioner', 283, 'Beauty > Women > Hair > Shampoo & Conditioner', NULL, 4,false,false,true,now(), now()) ,
          (286, 'Coloured', 285, 'Beauty > Women > Hair > Shampoo & Conditioner > Coloured', NULL, 5,false,false,true,now(), now()) ,
          (287, 'Curly & Wavy', 285, 'Beauty > Women > Hair > Shampoo & Conditioner > Curly & Wavy', NULL, 5,false,false,true,now(), now()) ,
          (288, 'Dry', 285, 'Beauty > Women > Hair > Shampoo & Conditioner > Dry', NULL, 5,false,false,true,now(), now()) ,
          (289, 'Hair Loss & Thinning', 285, 'Beauty > Women > Hair > Shampoo & Conditioner > Hair Loss & Thinning', NULL, 5,false,false,true,now(), now()) ,
          (290, 'Oily', 285, 'Beauty > Women > Hair > Shampoo & Conditioner > Oily', NULL, 5,false,false,true,now(), now()) ,
          (291, 'Styling', 283, 'Beauty > Women > Hair > Styling', NULL, 4,false,false,true,now(), now()) ,
          (292, 'Cream', 291, 'Beauty > Women > Hair > Styling > Cream', NULL, 5,false,false,true,now(), now()) ,
          (293, 'Men', 291, 'Beauty > Women > Hair > Styling > Men', NULL, 5,false,false,true,now(), now()) ,
          (294, 'Mousse', 291, 'Beauty > Women > Hair > Styling > Mousse', NULL, 5,false,false,true,now(), now()) ,
          (295, 'Spray', 291, 'Beauty > Women > Hair > Styling > Spray', NULL, 5,false,false,true,now(), now()) ,
          (296, 'Tools', 283, 'Beauty > Women > Hair > Tools', NULL, 4,false,false,true,now(), now()) ,
          (297, 'Brushes & Combs', 296, 'Beauty > Women > Hair > Tools > Brushes & Combs', NULL, 5,false,false,true,now(), now()) ,
          (298, 'Dryer', 296, 'Beauty > Women > Hair > Tools > Dryer', NULL, 5,false,false,true,now(), now()) ,
          (299, 'Treatments', 283, 'Beauty > Women > Hair > Treatments', NULL, 4,false,false,true,now(), now()) ,
          (300, 'Coloured', 299, 'Beauty > Women > Hair > Treatments > Coloured', NULL, 5,false,false,true,now(), now()) ,
          (301, 'Curly & Wavy', 299, 'Beauty > Women > Hair > Treatments > Curly & Wavy', NULL, 5,false,false,true,now(), now()) ,
          (302, 'Dry', 299, 'Beauty > Women > Hair > Treatments > Dry', NULL, 5,false,false,true,now(), now()) ,
          (303, 'Hair Loss & Thinning', 299, 'Beauty > Women > Hair > Treatments > Hair Loss & Thinning', NULL, 5,false,false,true,now(), now()) ,
          (304, 'Heat Protection', 299, 'Beauty > Women > Hair > Treatments > Heat Protection', NULL, 5,false,false,true,now(), now()) ,
          (305, 'Oily', 299, 'Beauty > Women > Hair > Treatments > Oily', NULL, 5,false,false,true,now(), now()) ,
          (306, 'Makeup', 251, 'Beauty > Women > Makeup', NULL, 3,false,false,true,now(), now()) ,
          (307, 'Cheek', 306, 'Beauty > Women > Makeup > Cheek', NULL, 4,false,false,true,now(), now()) ,
          (308, 'Blush', 307, 'Beauty > Women > Makeup > Cheek > Blush', NULL, 5,false,false,true,now(), now()) ,
          (309, 'Bronzer & Luminiser', 307, 'Beauty > Women > Makeup > Cheek > Bronzer & Luminiser', NULL, 5,false,false,true,now(), now()) ,
          (310, 'Tools', 307, 'Beauty > Women > Makeup > Cheek > Tools', NULL, 5,false,false,true,now(), now()) ,
          (311, 'Eyes', 306, 'Beauty > Women > Makeup > Eyes', NULL, 4,false,false,true,now(), now()) ,
          (312, 'Eyebrows', 311, 'Beauty > Women > Makeup > Eyes > Eyebrows', NULL, 5,false,false,true,now(), now()) ,
          (313, 'Eyeliner', 311, 'Beauty > Women > Makeup > Eyes > Eyeliner', NULL, 5,false,false,true,now(), now()) ,
          (314, 'Eyeshadow', 311, 'Beauty > Women > Makeup > Eyes > Eyeshadow', NULL, 5,false,false,true,now(), now()) ,
          (315, 'False Eyelashes', 311, 'Beauty > Women > Makeup > Eyes > False Eyelashes', NULL, 5,false,false,true,now(), now()) ,
          (316, 'Mascara', 311, 'Beauty > Women > Makeup > Eyes > Mascara', NULL, 5,false,false,true,now(), now()) ,
          (317, 'Primer', 311, 'Beauty > Women > Makeup > Eyes > Primer', NULL, 5,false,false,true,now(), now()) ,
          (318, 'Tools', 311, 'Beauty > Women > Makeup > Eyes > Tools', NULL, 5,false,false,true,now(), now()) ,
          (319, 'Under Eye Concealer', 311, 'Beauty > Women > Makeup > Eyes > Under Eye Concealer', NULL, 5,false,false,true,now(), now()) ,
          (320, 'Face', 306, 'Beauty > Women > Makeup > Face', NULL, 4,false,false,true,now(), now()) ,
          (321, 'CC & BB Cream', 320, 'Beauty > Women > Makeup > Face > CC & BB Cream', NULL, 5,false,false,true,now(), now()) ,
          (322, 'Concealer', 320, 'Beauty > Women > Makeup > Face > Concealer', NULL, 5,false,false,true,now(), now()) ,
          (323, 'Contouring', 320, 'Beauty > Women > Makeup > Face > Contouring', NULL, 5,false,false,true,now(), now()) ,
          (324, 'Face Powder', 320, 'Beauty > Women > Makeup > Face > Face Powder', NULL, 5,false,false,true,now(), now()) ,
          (325, 'Foundation', 320, 'Beauty > Women > Makeup > Face > Foundation', NULL, 5,false,false,true,now(), now()) ,
          (326, 'Primer', 320, 'Beauty > Women > Makeup > Face > Primer', NULL, 5,false,false,true,now(), now()) ,
          (327, 'Tools', 320, 'Beauty > Women > Makeup > Face > Tools', NULL, 5,false,false,true,now(), now()) ,
          (328, 'Lips', 306, 'Beauty > Women > Makeup > Lips', NULL, 4,false,false,true,now(), now()) ,
          (329, 'Enhancers & Treatments', 328, 'Beauty > Women > Makeup > Lips > Enhancers & Treatments', NULL, 5,false,false,true,now(), now()) ,
          (330, 'Lip Balm', 328, 'Beauty > Women > Makeup > Lips > Lip Balm', NULL, 5,false,false,true,now(), now()) ,
          (331, 'Lip Gloss', 328, 'Beauty > Women > Makeup > Lips > Lip Gloss', NULL, 5,false,false,true,now(), now()) ,
          (332, 'Lip Liner', 328, 'Beauty > Women > Makeup > Lips > Lip Liner', NULL, 5,false,false,true,now(), now()) ,
          (333, 'Lip Stain', 328, 'Beauty > Women > Makeup > Lips > Lip Stain', NULL, 5,false,false,true,now(), now()) ,
          (334, 'Lipstick', 328, 'Beauty > Women > Makeup > Lips > Lipstick', NULL, 5,false,false,true,now(), now()) ,
          (335, 'Tools', 328, 'Beauty > Women > Makeup > Lips > Tools', NULL, 5,false,false,true,now(), now()) ,
          (336, 'Nails', 306, 'Beauty > Women > Makeup > Nails', NULL, 4,false,false,true,now(), now()) ,
          (337, 'Base Coat & Top Coat', 336, 'Beauty > Women > Makeup > Nails > Base Coat & Top Coat', NULL, 5,false,false,true,now(), now()) ,
          (338, 'Nail Polish', 336, 'Beauty > Women > Makeup > Nails > Nail Polish', NULL, 5,false,false,true,now(), now()) ,
          (339, 'Nail Polish Remover', 336, 'Beauty > Women > Makeup > Nails > Nail Polish Remover', NULL, 5,false,false,true,now(), now()) ,
          (340, 'Tools', 336, 'Beauty > Women > Makeup > Nails > Tools', NULL, 5,false,false,true,now(), now()) ,
          (341, 'Treatments', 336, 'Beauty > Women > Makeup > Nails > Treatments', NULL, 5,false,false,true,now(), now()) ,
          (342, 'Men', 250, 'Beauty > Men', NULL, 2,false,false,true,now(), now()) ,
          (343, 'Bath & Body', 342, 'Beauty > Men > Bath & Body', NULL, 3,false,false,true,now(), now()) ,
          (344, 'Bath Sponges', 343, 'Beauty > Men > Bath & Body > Bath Sponges', NULL, 4,false,false,true,now(), now()) ,
          (345, 'Body Wash', 343, 'Beauty > Men > Bath & Body > Body Wash', NULL, 4,false,false,true,now(), now()) ,
          (346, 'Deodorant', 343, 'Beauty > Men > Bath & Body > Deodorant', NULL, 4,false,false,true,now(), now()) ,
          (347, 'Moisturiser', 343, 'Beauty > Men > Bath & Body > Moisturiser', NULL, 4,false,false,true,now(), now()) ,
          (348, 'Eyes', 342, 'Beauty > Men > Eyes', NULL, 3,false,false,true,now(), now()) ,
          (349, 'Face', 342, 'Beauty > Men > Face', NULL, 3,false,false,true,now(), now()) ,
          (350, 'Cleanser & Toner', 349, 'Beauty > Men > Face > Cleanser & Toner', NULL, 4,false,false,true,now(), now()) ,
          (351, 'Moisturiser', 349, 'Beauty > Men > Face > Moisturiser', NULL, 4,false,false,true,now(), now()) ,
          (352, 'Serum & Treatments', 349, 'Beauty > Men > Face > Serum & Treatments', NULL, 4,false,false,true,now(), now()) ,
          (353, 'Fragrance', 342, 'Beauty > Men > Fragrance', NULL, 3,false,false,true,now(), now()) ,
          (354, 'Hair', 342, 'Beauty > Men > Hair', NULL, 3,false,false,true,now(), now()) ,
          (355, 'Shampoo & Conditioner', 354, 'Beauty > Men > Hair > Shampoo & Conditioner', NULL, 4,false,false,true,now(), now()) ,
          (356, 'Styling', 354, 'Beauty > Men > Hair > Styling', NULL, 4,false,false,true,now(), now()) ,
          (357, 'Shaving', 342, 'Beauty > Men > Shaving', NULL, 3,false,false,true,now(), now()) ,
          (358, 'After Shave', 357, 'Beauty > Men > Shaving > After Shave', NULL, 4,false,false,true,now(), now()) ,
          (359, 'Shaving Cream', 357, 'Beauty > Men > Shaving > Shaving Cream', NULL, 4,false,false,true,now(), now()) ,
          (360, 'Skincare', 251, 'Beauty > Women > Skincare', NULL, 3,false,false,true,now(), now()) ,
          (361, 'Acne', 360, 'Beauty > Women > Skincare > Acne', NULL, 4,false,false,true,now(), now()) ,
          (362, 'Anti-ageing', 360, 'Beauty > Women > Skincare > Anti-ageing', NULL, 4,false,false,true,now(), now()) ,
          (363, 'Cleanse', 360, 'Beauty > Women > Skincare > Cleanse', NULL, 4,false,false,true,now(), now()) ,
          (364, 'Devices', 363, 'Beauty > Women > Skincare > Cleanse > Devices', NULL, 5,false,false,true,now(), now()) ,
          (365, 'Exfoliator', 363, 'Beauty > Women > Skincare > Cleanse > Exfoliator', NULL, 5,false,false,true,now(), now()) ,
          (366, 'Face Wash', 363, 'Beauty > Women > Skincare > Cleanse > Face Wash', NULL, 5,false,false,true,now(), now()) ,
          (367, 'Toner', 363, 'Beauty > Women > Skincare > Cleanse > Toner', NULL, 5,false,false,true,now(), now()) ,
          (368, 'Combination', 360, 'Beauty > Women > Skincare > Combination', NULL, 4,false,false,true,now(), now()) ,
          (369, 'Dry', 360, 'Beauty > Women > Skincare > Dry', NULL, 4,false,false,true,now(), now()) ,
          (370, 'Moisturise', 360, 'Beauty > Women > Skincare > Moisturise', NULL, 4,false,false,true,now(), now()) ,
          (371, 'BB & CC Cream', 370, 'Beauty > Women > Skincare > Moisturise > BB & CC Cream', NULL, 5,false,false,true,now(), now()) ,
          (372, 'Day Moisturiser', 370, 'Beauty > Women > Skincare > Moisturise > Day Moisturiser', NULL, 5,false,false,true,now(), now()) ,
          (373, 'Decollete & Neck', 370, 'Beauty > Women > Skincare > Moisturise > Decollete & Neck', NULL, 5,false,false,true,now(), now()) ,
          (374, 'Face Oil', 370, 'Beauty > Women > Skincare > Moisturise > Face Oil', NULL, 5,false,false,true,now(), now()) ,
          (375, 'Night Cream', 370, 'Beauty > Women > Skincare > Moisturise > Night Cream', NULL, 5,false,false,true,now(), now()) ,
          (376, 'Oily', 360, 'Beauty > Women > Skincare > Oily', NULL, 4,false,false,true,now(), now()) ,
          (377, 'Sensitive', 360, 'Beauty > Women > Skincare > Sensitive', NULL, 4,false,false,true,now(), now()) ,
          (378, 'Serum & Treatments', 360, 'Beauty > Women > Skincare > Serum & Treatments', NULL, 4,false,false,true,now(), now()) ,
          (379, 'Eye', 378, 'Beauty > Women > Skincare > Serum & Treatments > Eye', NULL, 5,false,false,true,now(), now()) ,
          (380, 'Mask', 378, 'Beauty > Women > Skincare > Serum & Treatments > Mask', NULL, 5,false,false,true,now(), now()) ,
          (381, 'Peel', 378, 'Beauty > Women > Skincare > Serum & Treatments > Peel', NULL, 5,false,false,true,now(), now()) ,
          (382, 'Serum', 378, 'Beauty > Women > Skincare > Serum & Treatments > Serum', NULL, 5,false,false,true,now(), now()) ,
          (383, 'Suncare', 360, 'Beauty > Women > Skincare > Suncare', NULL, 4,false,false,true,now(), now()) ,
          (384, 'Self Tanning', 383, 'Beauty > Women > Skincare > Suncare > Self Tanning', NULL, 5,false,false,true,now(), now()) ,
          (385, 'Sun Protection', 383, 'Beauty > Women > Skincare > Suncare > Sun Protection', NULL, 5,false,false,true,now(), now()) ,
          (386, 'Uneven Skintone', 360, 'Beauty > Women > Skincare > Uneven Skintone', NULL, 4,false,false,true,now(), now()) ,
          (387, 'Whitening & Brightening', 360, 'Beauty > Women > Skincare > Whitening & Brightening', NULL, 4,false,false,true,now(), now()) ,
          (388, 'Tools & Brushes', 251, 'Beauty > Women > Tools & Brushes', NULL, 3,false,false,true,now(), now()) ,
          (389, 'Bags & Travel Cases', 388, 'Beauty > Women > Tools & Brushes > Bags & Travel Cases', NULL, 4,false,false,true,now(), now()) ,
          (390, 'Palette Organiser', 389, 'Beauty > Women > Tools & Brushes > Bags & Travel Cases > Palette Organiser', NULL, 5,false,false,true,now(), now()) ,
          (391, 'Professional Case', 389, 'Beauty > Women > Tools & Brushes > Bags & Travel Cases > Professional Case', NULL, 5,false,false,true,now(), now()) ,
          (392, 'Toiletry Bag', 389, 'Beauty > Women > Tools & Brushes > Bags & Travel Cases > Toiletry Bag', NULL, 5,false,false,true,now(), now()) ,
          (393, 'Brushes & Applicators', 388, 'Beauty > Women > Tools & Brushes > Brushes & Applicators', NULL, 4,false,false,true,now(), now()) ,
          (394, 'Cheek', 393, 'Beauty > Women > Tools & Brushes > Brushes & Applicators > Cheek', NULL, 5,false,false,true,now(), now()) ,
          (395, 'Cleaners', 393, 'Beauty > Women > Tools & Brushes > Brushes & Applicators > Cleaners', NULL, 5,false,false,true,now(), now()) ,
          (396, 'Eyes', 393, 'Beauty > Women > Tools & Brushes > Brushes & Applicators > Eyes', NULL, 5,false,false,true,now(), now()) ,
          (397, 'Face', 393, 'Beauty > Women > Tools & Brushes > Brushes & Applicators > Face', NULL, 5,false,false,true,now(), now()) ,
          (398, 'Lips', 393, 'Beauty > Women > Tools & Brushes > Brushes & Applicators > Lips', NULL, 5,false,false,true,now(), now()) ,
          (399, 'Sets', 393, 'Beauty > Women > Tools & Brushes > Brushes & Applicators > Sets', NULL, 5,false,false,true,now(), now()) ,
          (400, 'Sponges & Applicators', 393, 'Beauty > Women > Tools & Brushes > Brushes & Applicators > Sponges & Applicators', NULL, 5,false,false,true,now(), now()) ,
          (401, 'Devices', 388, 'Beauty > Women > Tools & Brushes > Devices', NULL, 4,false,false,true,now(), now()) ,
          (402, 'Skincare', 401, 'Beauty > Women > Tools & Brushes > Devices > Skincare', NULL, 5,false,false,true,now(), now()) ,
          (403, 'Hair Tools', 388, 'Beauty > Women > Tools & Brushes > Hair Tools', NULL, 4,false,false,true,now(), now()) ,
          (404, 'Brushes & Combs', 403, 'Beauty > Women > Tools & Brushes > Hair Tools > Brushes & Combs', NULL, 5,false,false,true,now(), now()) ,
          (405, 'Small Tools', 388, 'Beauty > Women > Tools & Brushes > Small Tools', NULL, 4,false,false,true,now(), now()) ,
          (406, 'Eyelash Curler', 405, 'Beauty > Women > Tools & Brushes > Small Tools > Eyelash Curler', NULL, 5,false,false,true,now(), now()) ,
          (407, 'Manicure & Pedicure', 405, 'Beauty > Women > Tools & Brushes > Small Tools > Manicure & Pedicure', NULL, 5,false,false,true,now(), now()) ,
          (408, 'Mirrors', 405, 'Beauty > Women > Tools & Brushes > Small Tools > Mirrors', NULL, 5,false,false,true,now(), now()) ,
          (409, 'Pencil Sharpener', 405, 'Beauty > Women > Tools & Brushes > Small Tools > Pencil Sharpener', NULL, 5,false,false,true,now(), now()) ,
          (410, 'Tweezers & Eyebrows', 405, 'Beauty > Women > Tools & Brushes > Small Tools > Tweezers & Eyebrows', NULL, 5,false,false,true,now(), now());
      SQL
  end
end
