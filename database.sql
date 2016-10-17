CREATE TABLE customers (
  id bigserial primary key,
  name varchar(20) NOT NULL,
  lastname varchar(20)  NOT NULL,
  age integer,
  code integer
);