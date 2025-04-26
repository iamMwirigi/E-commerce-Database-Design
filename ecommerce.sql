

-- Disable foreign key checks temporarily
SET FOREIGN_KEY_CHECKS = 0;

-- Create the database
DROP DATABASE IF EXISTS ecommerce;
CREATE DATABASE ecommerce;
USE ecommerce;



-- Brand table
CREATE TABLE brand (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  logo_url VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Product category table (supports hierarchy)
CREATE TABLE product_category (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  parent_id INT NULL,
  image_url VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (parent_id) REFERENCES product_category(id)
);

-- Product table
CREATE TABLE product (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  brand_id INT NOT NULL,
  category_id INT NOT NULL,
  base_price DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (brand_id) REFERENCES brand(id),
  FOREIGN KEY (category_id) REFERENCES product_category(id)
);

-- Product variations (color, size, etc.)
CREATE TABLE product_variation (
  id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT NOT NULL,
  variation_type VARCHAR(50) NOT NULL,
  variation_value VARCHAR(100) NOT NULL,
  FOREIGN KEY (product_id) REFERENCES product(id)
);

-- Product items (specific variations with inventory)
CREATE TABLE product_item (
  id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT NOT NULL,
  sku VARCHAR(100) NOT NULL UNIQUE,
  price DECIMAL(10,2) NOT NULL,
  quantity_in_stock INT NOT NULL DEFAULT 0,
  FOREIGN KEY (product_id) REFERENCES product(id)
);

-- Product images
CREATE TABLE product_image (
  id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT NOT NULL,
  image_url VARCHAR(255) NOT NULL,
  is_primary BOOLEAN DEFAULT FALSE,
  alt_text VARCHAR(100),
  display_order INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES product(id)
);

-- Attribute categories
CREATE TABLE attribute_category (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

-- Attribute types
CREATE TABLE attribute_type (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL
);

-- Product attributes
CREATE TABLE product_attribute (
  id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT NOT NULL,
  attribute_category_id INT NOT NULL,
  attribute_type_id INT NOT NULL,
  value VARCHAR(255) NOT NULL,
  FOREIGN KEY (product_id) REFERENCES product(id),
  FOREIGN KEY (attribute_category_id) REFERENCES attribute_category(id),
  FOREIGN KEY (attribute_type_id) REFERENCES attribute_type(id)
);


-- Insert sample brands
INSERT INTO brand (name, description, logo_url) VALUES 
('Nike', 'American athletic footwear and apparel corporation', 'https://via.placeholder.com/150?text=Nike+Logo'),
('Apple', 'American multinational technology company', 'https://via.placeholder.com/150?text=Apple+Logo'),
('Samsung', 'South Korean multinational electronics company', 'https://via.placeholder.com/150?text=Samsung+Logo');

-- Insert categories
INSERT INTO product_category (name, parent_id, image_url) VALUES 
('Electronics', NULL, 'https://via.placeholder.com/300x200?text=Electronics'),
('Clothing', NULL, 'https://via.placeholder.com/300x200?text=Clothing'),
('Smartphones', 1, 'https://via.placeholder.com/300x200?text=Smartphones'),
('Laptops', 1, 'https://via.placeholder.com/300x200?text=Laptops'),
('Shoes', 2, 'https://via.placeholder.com/300x200?text=Shoes');

-- Insert products
INSERT INTO product (name, description, brand_id, category_id, base_price) VALUES 
('iPhone 13', 'Latest iPhone model with A15 Bionic chip', 2, 3, 999.99),
('Galaxy S21', 'Samsung flagship phone with 120Hz display', 3, 3, 899.99),
('Air Max 90', 'Iconic Nike sneakers with visible air cushioning', 1, 5, 120.00),
('MacBook Pro', 'Professional laptop with M1 Pro chip', 2, 4, 1999.99);

-- Insert variations
INSERT INTO product_variation (product_id, variation_type, variation_value) VALUES 
(1, 'color', 'Midnight'),
(1, 'color', 'Starlight'),
(1, 'storage', '128GB'),
(1, 'storage', '256GB'),
(2, 'color', 'Phantom Black'),
(2, 'color', 'Phantom White'),
(3, 'color', 'Black'),
(3, 'color', 'White'),
(3, 'size', 'US 8'),
(3, 'size', 'US 9'),
(3, 'size', 'US 10'),
(4, 'storage', '512GB'),
(4, 'storage', '1TB'),
(4, 'memory', '16GB'),
(4, 'memory', '32GB');

-- Insert product items (combinations of variations)
INSERT INTO product_item (product_id, sku, price, quantity_in_stock) VALUES 
(1, 'IP13-MID-128', 999.99, 50),
(1, 'IP13-MID-256', 1099.99, 30),
(1, 'IP13-STAR-128', 999.99, 40),
(3, 'AM90-BLK-8', 120.00, 100),
(3, 'AM90-BLK-9', 120.00, 80),
(3, 'AM90-WHT-8', 120.00, 60),
(3, 'AM90-WHT-9', 120.00, 45),
(4, 'MBP-512-16', 1999.99, 25),
(4, 'MBP-1TB-32', 2499.99, 15);

-- Insert product images
INSERT INTO product_image (product_id, image_url, is_primary, alt_text, display_order) VALUES 
-- iPhone 13 images
(1, 'https://via.placeholder.com/800x600?text=iPhone+13+Front', TRUE, 'iPhone 13 front view', 1),
(1, 'https://via.placeholder.com/800x600?text=iPhone+13+Back', FALSE, 'iPhone 13 back view', 2),
(1, 'https://via.placeholder.com/800x600?text=iPhone+13+Side', FALSE, 'iPhone 13 side view', 3),
-- Air Max 90 images
(3, 'https://via.placeholder.com/800x600?text=Air+Max+90+Front', TRUE, 'Air Max 90 front view', 1),
(3, 'https://via.placeholder.com/800x600?text=Air+Max+90+Side', FALSE, 'Air Max 90 side view', 2),
(3, 'https://via.placeholder.com/800x600?text=Air+Max+90+Detail', FALSE, 'Air Max 90 sole detail', 3),
-- MacBook Pro images
(4, 'https://via.placeholder.com/800x600?text=MacBook+Pro+Open', TRUE, 'MacBook Pro open view', 1),
(4, 'https://via.placeholder.com/800x600?text=MacBook+Pro+Closed', FALSE, 'MacBook Pro closed view', 2);

-- Insert attribute categories and types
INSERT INTO attribute_category (name) VALUES 
('Physical'),
('Technical'),
('Materials'),
('Display'),
('Camera');

INSERT INTO attribute_type (name) VALUES 
('text'),
('number'),
('boolean'),
('dimension');

-- Insert product attributes
INSERT INTO product_attribute (product_id, attribute_category_id, attribute_type_id, value) VALUES 
-- iPhone 13 attributes
(1, 2, 1, 'A15 Bionic chip'),
(1, 2, 2, '6.1'),
(1, 2, 2, '3240'),
(1, 4, 1, 'Super Retina XDR'),
(1, 5, 1, 'Dual 12MP camera system'),
-- Air Max 90 attributes
(3, 3, 1, 'Leather and mesh upper'),
(3, 1, 4, '12 x 8 x 5 inches'),
(3, 1, 2, '0.8'),
-- MacBook Pro attributes
(4, 2, 1, 'M1 Pro chip'),
(4, 2, 2, '16'),
(4, 4, 1, 'Liquid Retina XDR');



-- Product catalog view
CREATE VIEW product_catalog AS
SELECT 
  p.id,
  p.name,
  p.description,
  b.name AS brand,
  pc.name AS category,
  p.base_price,
  (SELECT image_url FROM product_image WHERE product_id = p.id AND is_primary = TRUE LIMIT 1) AS primary_image,
  MIN(pi.price) AS min_price,
  MAX(pi.price) AS max_price
FROM product p
JOIN brand b ON p.brand_id = b.id
JOIN product_category pc ON p.category_id = pc.id
LEFT JOIN product_item pi ON p.id = pi.product_id
GROUP BY p.id;

-- Product inventory view
CREATE VIEW product_inventory AS
SELECT 
  p.name AS product_name,
  pi.sku,
  pi.price,
  pi.quantity_in_stock,
  GROUP_CONCAT(DISTINCT CONCAT(pv.variation_type, ': ', pv.variation_value) 
    ORDER BY pv.variation_type SEPARATOR ' | ') AS variations
FROM product_item pi
JOIN product p ON pi.product_id = p.id
JOIN product_variation pv ON pv.product_id = p.id
GROUP BY pi.id;

-- Product images view
CREATE VIEW product_images_view AS
SELECT 
  p.id AS product_id,
  p.name AS product_name,
  pi.image_url,
  pi.alt_text,
  pi.display_order
FROM product p
JOIN product_image pi ON p.id = pi.product_id
ORDER BY p.id, pi.display_order;



-- Procedure to get complete product details
DELIMITER //
CREATE PROCEDURE GetProductDetails(IN p_product_id INT)
BEGIN
  -- Product info
  SELECT * FROM product WHERE id = p_product_id;
  
  -- Product variations
  SELECT variation_type, GROUP_CONCAT(variation_value) AS options
  FROM product_variation 
  WHERE product_id = p_product_id
  GROUP BY variation_type;
  
  -- Product items with inventory
  SELECT * FROM product_item WHERE product_id = p_product_id;
  
  -- Product images
  SELECT * FROM product_image 
  WHERE product_id = p_product_id
  ORDER BY is_primary DESC, display_order;
  
  -- Product attributes
  SELECT 
    ac.name AS category,
    at.name AS type,
    pa.value
  FROM product_attribute pa
  JOIN attribute_category ac ON pa.attribute_category_id = ac.id
  JOIN attribute_type at ON pa.attribute_type_id = at.id
  WHERE pa.product_id = p_product_id;
END //
DELIMITER ;

-- Procedure to update inventory
DELIMITER //
CREATE PROCEDURE UpdateInventory(
  IN p_item_id INT,
  IN p_quantity_change INT,
  OUT p_new_quantity INT,
  OUT p_success BOOLEAN
)
BEGIN
  DECLARE current_qty INT;
  
  START TRANSACTION;
  
  SELECT quantity_in_stock INTO current_qty 
  FROM product_item 
  WHERE id = p_item_id 
  FOR UPDATE;
  
  IF current_qty + p_quantity_change >= 0 THEN
    UPDATE product_item 
    SET quantity_in_stock = quantity_in_stock + p_quantity_change
    WHERE id = p_item_id;
    
    SET p_new_quantity = current_qty + p_quantity_change;
    SET p_success = TRUE;
    COMMIT;
  ELSE
    SET p_new_quantity = current_qty;
    SET p_success = FALSE;
    ROLLBACK;
  END IF;
END //
DELIMITER ;

-- Procedure to get all product images
DELIMITER //
CREATE PROCEDURE GetProductImages(IN p_product_id INT)
BEGIN
  SELECT 
    id,
    image_url,
    alt_text,
    is_primary,
    display_order
  FROM product_image
  WHERE product_id = p_product_id
  ORDER BY is_primary DESC, display_order;
END //
DELIMITER ;



-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;
