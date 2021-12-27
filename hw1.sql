SELECT * FROM (Chessboard AS cb JOIN chessman as cm ON cb.cid=cm.cid);
SELECT * FROM chessboard;
SELECT * FROM chessman;
--INSERT INTO chessboard(cid, x, y) VALUES(21, 'C', 6),(22, 'C', 7), (23, 'C', 8), (24,'F', 2 ) ; 
--DELETE FROM chessboard WHERE cid=4;
--1--
SELECT COUNT(*) FROM Chessboard;
--2--
SELECT cb.cid FROM (Chessboard AS cb JOIN chessman as cm ON cb.cid=cm.cid) WHERE type LIKE 'k%';
--3--
SELECT type, COUNT(*) FROM chessman GROUP BY type;
--4--
SELECT cb.cid FROM (Chessboard AS cb JOIN chessman as cm ON cb.cid=cm.cid) 
	WHERE type = 'pawn' AND color = 'white';
--5--
SELECT cm.type, cm.color FROM (Chessboard AS cb JOIN chessman as cm ON cb.cid=cm.cid) 
	WHERE (ASCII(x) -  y = 64);
--6--
SELECT color, COUNT(*) FROM (Chessboard AS cb JOIN chessman as cm ON cb.cid=cm.cid) GROUP BY color;
--7--
SELECT type FROM (Chessboard AS cb JOIN chessman as cm ON cb.cid=cm.cid) WHERE color='black';
--8--
SELECT type, COUNT(*) FROM (Chessboard AS cb JOIN chessman as cm ON cb.cid=cm.cid) WHERE color='black' GROUP BY type;
--9--
SELECT type, COUNT(*) INTO tmp FROM (Chessboard AS cb JOIN chessman as cm ON cb.cid=cm.cid)  GROUP BY type;
	SELECT type FROM tmp WHERE COUNT > 1;
	DROP TABLE tmp;
--10--
SELECT color  FROM (Chessboard AS cb JOIN chessman as cm ON cb.cid=cm.cid)
	GROUP BY color ORDER BY COUNT(*) DESC LIMIT 1;
----
SELECT cb.cid, x, y, color, type INTO allinf FROM (Chessboard AS cb JOIN chessman as cm ON cb.cid=cm.cid);
SELECT * FROM allinf;
DROP TABLE allinf;

-- 11 --
SELECT cid, type FROM allinf as a1 WHERE (x in 
										(SELECT x FROM allinf WHERE type = 'rook')
									or y in 
										(SELECT y FROM allinf WHERE type = 'rook'))
									and a1.type != 'rook';
-- 12 --
SELECT color FROM allinf as a1 WHERE type='pawn' GROUP BY color HAVING COUNT(*) = 
																		(SELECT COUNT(*) FROM chessman as ch WHERE ch.type='pawn'
																		and a1.color = ch.color);
--13--
DROP TABLE board1, board2;
SELECT * INTO board1 FROM chessboard;
SELECT * INTO board2 FROM chessboard;
DELETE FROM board2 WHERE cid=3 or cid=4;
UPDATE board2 SET x='B' WHERE cid=6;
UPDATE board2 SET y=2 WHERE cid=20;
SELECT * FROM board1;
SELECT * from board2;

SELECT board1.cid FROM(board1 LEFT JOIN board2 ON board1.cid=board2.cid)
	WHERE board1.x != board2.x OR board1.y != board2.y OR (board2.x IS NULL);
--14--
SELECT a1.cid FROM allinf as a1, allinf as a2 WHERE ABS(a1.y - a2.y) <= 2 and (a1.cid != a2.cid) 
								and (a2.type='king' AND a2.color='black')
									and ABS(ASCII(a1.x) - ASCII(a2.x)) <= 2
									
--15--
SELECT a1.cid FROM allinf as a1, allinf as a2 WHERE a2.type = 'king' and a2.color = 'white'
								 and ABS(a1.y - a2.y) + ABS(ASCII(a1.x) - ASCII(a2.x)) = 
								 (SELECT MIN(ABS(a1.y - a2.y) + ABS(ASCII(a1.x) - ASCII(a2.x)))  
								 FROM allinf as a1, allinf as a2 
								 WHERE (a2.type = 'king' and a2.color = 'white') and (a1.type != 'king' or a1.color != 'white'));
----
DROP TABLE allinf;
	
