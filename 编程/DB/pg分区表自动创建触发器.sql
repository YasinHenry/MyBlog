CREATE FUNCTION sales_order_insert_trigger()
RETURNS trigger
AS $$
BEGIN
  IF ( NEW.order_date >= DATE '2000-01-01' AND NEW.order_date < DATE '2001-01-01' ) THEN
    INSERT INTO sales_order_y2000 VALUES (NEW.*);
  ELSIF ( NEW.order_date >= DATE '2001-01-01' AND NEW.order_date < DATE '2002-01-01' ) THEN
    INSERT INTO sales_order_y2001 VALUES (NEW.*);
  ELSE
    RAISE EXCEPTION 'Date out of range. Fix the sales_order_insert_trigger() function!';
  END IF;
  RETURN NULL;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER sales_order_insert
  BEFORE INSERT ON sales_order
  FOR EACH ROW EXECUTE FUNCTION sales_order_insert_trigger();