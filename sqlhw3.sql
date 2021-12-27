create view allinf as 
	SELECT cb.cid, x, y, color, type  FROM (Chessboard AS cb JOIN chessman as cm ON cb.cid=cm.cid);
select * from allinf;

-- step procedure -- 

CREATE OR REPLACE function go_rook(id_ int, X_ char,Y_ int) RETURNS VOID
AS
$$
DECLARE prev_x char(1);
DECLARE prev_y int;
BEGIN
SELECT x, y  INTO prev_x, prev_y from chessboard WHERE cid = id_;
CASE 
		WHEN (ASCII('A') <= ASCII(X_) and ASCII(X_) <= ASCII('H')
			and 1 <= Y_ and Y_ <= 8 ) and (ASCII(prev_x) = ASCII(X_) or prev_y = Y_)
		THEN
			UPDATE chessboard  SET x=X_, y=Y_ where cid = id_ ;
		ELSE 
			RAISE NOTICE 'coordinates are incorrect';
		END CASE;
END
$$ LANGUAGE plpgsql;
	
select * from chessman;
INSERT INTO chessboard(cid, x, y) VALUES (2, 'B', 2);
SELECT go_rook(6, 'D', 3);
SELECT go_rook(6, 'B', 3);
select * from allinf;

-- task 1 --

CREATE OR REPLACE function check_rook_step() RETURNS trigger AS
$$
DECLARE rook_color char(5);
BEGIN
RAISE NOTICE 'trigger worked';
RAISE NOTICE 'found change in % % %',NEW.cid, NEW.x, NEW.y ;
SELECT color into rook_color from chessman as cm WHERE cm.cid = NEW.cid;
CASE 
	WHEN EXISTS (
		SELECT r.cid
		FROM chessboard as r join chessman as cm on r.cid = cm.cid 
		WHERE  r.x = NEW.x and r.y = NEW.y and r.cid != NEW.cid and cm.color != rook_color)
	THEN RAISE NOTICE 'found smth to eat';
	DELETE from chessboard as r WHERE r.x = NEW.x and r.y = NEW.y and r.cid != NEW.cid;
	return NEW;
	WHEN EXISTS (
		SELECT r.cid
		FROM chessboard as r join chessman as cm on r.cid = cm.cid 
		WHERE  r.x = NEW.x and r.y = NEW.y and r.cid != NEW.cid and cm.color = rook_color)
	THEN RAISE NOTICE 'sorry';
	RETURN OLD;
	ELSE RAISE NOTICE 'still hungry';
	return NEW;
END CASE;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER eat_or_pass 
	BEFORE UPDATE ON chessboard
	FOR EACH ROW
	WHEN (OLD.x is DISTINCT from NEW.x  or  OLD.y is DISTINCT from NEW.y)
	EXECUTE PROCEDURE check_rook_step();


--task 2--

CREATE TABLE history(cid int, type char(5), x_from char(1), x_to char(1), y_from int, y_to int);

CREATE OR REPLACE function update_history() RETURNS trigger AS
$$
BEGIN
CASE TG_OP
	WHEN 'UPDATE'
	THEN INSERT INTO history(cid, type, x_from, x_to, y_from, y_to) VALUES (NEW.cid, 'go to', OLD.x, NEW.x, OLD.y, NEW.y);
	WHEN 'DELETE'
	THEN INSERT INTO history(cid, type, x_from, y_from) VALUES (old.cid, 'dead', OLD.x, OLD.y);
END CASE;
return NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER history 
	AFTER UPDATE OR DELETE ON chessboard
	FOR EACH ROW
	EXECUTE PROCEDURE update_history();
	
SELECT go_rook(6, 'B', 5);
SELECT * FROM history;
