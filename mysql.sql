USE shopdb;

CREATE TABLE product (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    price DOUBLE
);

INSERT INTO product(name, price)
VALUES ('Áo', 100000),
       ('Quần', 200000);