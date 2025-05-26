
INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES ('pizzadelivery', 'Pizza Delivery', 0);


CREATE TABLE IF NOT EXISTS `pizza_deliveries` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `citizenid` VARCHAR(50) NOT NULL,
  `order_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `delivery_address` VARCHAR(255) NOT NULL,
  `reward` INT NOT NULL DEFAULT 0,
  `status` ENUM('pending', 'in_progress', 'delivered', 'cancelled') NOT NULL DEFAULT 'pending',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;