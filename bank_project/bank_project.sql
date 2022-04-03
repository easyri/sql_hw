-- справочник клиентов (ФИО, адрес, паспортные данные)
-- справочник городов (неуникальное название, количество населения)
-- список счетов, открытых для клиентов (номер счета, валюта счета, дата открытия, дата закрытия, сумма доступных средств)
-- справочник валют (название, ISO символ, ISO номер)
-- справочник типов операций, осуществляемых над счетом (название операции, знак операции)
-- реестр операций над счетом (счет, тип операции, сумма операции, дата операции)

create table clients(passid int primary key, fname char(20), lname char(20), mname char(20), city int);
create table cities(cid int primary key, name char(10));
create table accounts(aid int generated always as identity primary key, passid int, cy int, odate date, cdate date, balance int);
create table currencies( iso int primary key, name char(10), iso_name char(2));
create table operations(oid int primary key, name char(10));
create table ophistory(ohid int generated always as identity primary key, oid int, aid int, sum int, odate date);

alter table clients add constraint city_is_city foreign key (city) references cities(cid);
alter table accounts add constraint passid_is_client foreign key(passid) references clients(passid);
alter table accounts add constraint cy_is_iso foreign key(cy) references currencies(iso);
alter table ophistory add constraint oid_is_op foreign key(oid) references operations(oid);
alter table ophistory add constraint aid_is_acc foreign key(aid) references accounts(aid);

insert into cities(cid, name) values (1, 'msc'), (2, 'spb'), (3, 'vrn'), (4, 'novosib'), (5, 'ekb');
insert into currencies(iso, iso_name) values (1, 'ru'), (2, 'us'), (3, 'eu');
insert into operations(oid, name) values
		(1, 'add'),
		(2, 'subtract');
insert into clients(passid, fname, lname, mname, city) values 
	(123, 'ivanov', 'ivan', 'ivanovich', 1),
	(100, 'petrov', 'ivan', 'ivanovich', 1),
	(101, 'sidorov', 'ivan', 'ivanovich', 1),
	(102, 'kuznezov', 'pavel', 'myhailovich', 1),
	(103, 'petrov', 'pavel', 'myhailovich', 2),
	(104, 'petrova', 'maria', 'myhailovna', 2),
	(105, 'sidorova', 'anna', 'myhailovna', 3),
	(106, 'ivanova', 'galina', 'ivanovna', 4),
	(107, 'katz', 'maxim', 'ivanovich', 3),
	(108, 'borodavko', 'ury', 'ivanovich', 2),
	(109, 'nikplenko', 'ivan', 'ivanovich', 2),
	(110, 'ivanov', 'petr', 'ivanovich', 1),
	(111, 'ivanov', 'mihail', 'petrovich', 2),
	(112, 'ivanov', 'vadim', 'ivanovich', 3),
	(113, 'dolin', 'anton', 'ivanovich', 1);
	
	
	
insert into accounts(passid, cy, odate, balance) values
	(123, 1, '2020-03-22', 1000),
	(123, 2, '2020-03-22', 1000),
	(100, 1, '2000-03-22', 1000),
	(101, 1, '2001-03-22', 2000),
	(102, 1, '2001-03-22', 0),
	(103, 2, '2002-05-12', 0),
	(104, 1, '2005-03-22', 3000),
	(104, 1, '2005-03-22', 500),
	(104, 3, '2006-03-22', 1000),
	(105, 1, '2005-03-22', 500),
	(106, 1, '2007-03-22', 1500),
	(107, 1, '2008-03-22', 2000),
	(108, 2, '2007-03-22', 1500),
	(109, 2, '2010-03-22', 1500),
	(113, 1, '2021-03-22', 1000),
	(106, 1, '2019-03-22', -1000),
	(107, 2, '2018-03-22', -500);
	
select * from accounts order by passid, cy;
		
insert into accounts(passid, cy, odate, cdate) values
	(110, 1, '2005-03-22', '2008-03-22'),
	(111, 2, '2006-03-22', '2008-03-21'),
	(112, 3, '2005-03-22', '2008-03-22');
	
	
insert into ophistory(oid, aid, sum, odate) values
	(1, 1, 100, '2021-01-10'),
	(1, 2, 100, '2020-01-10'),
	(1, 1, 100, '2021-02-10'),
	(1, 2, 100, '2020-02-10'),
	(2, 5, 500, '2005-01-10'),
	(2, 7, 500, '2006-01-10'),
	(1, 8, 500, '2006-01-10'),
	(2, 1, 200, '2021-01-15'),
	(2, 2, 100, '2020-07-10'),
	(2, 1, 500, '2021-02-10'),
	(1, 18, 100, '2021-01-10'),
	(2, 18, 100, '2021-01-10');


-- 1 Выбрать всех клиентов по фамилии “Иванов”.
-- 2 Выбрать всех клиентов, проживающих в Москве.
-- 3 Найти количество открытых после 20 августа 2004 года рублевых счетов.
-- 4 Вывести все счета и количество операций по этим счетам после 01.08.2004.
-- 5 Вывести все операции по рублевым счетам (номер операции, тип операции, сумма операции, дата операции).
-- 6 Вывести клиентов, у которых открыто несколько счетов.
-- 7 Вывести список населенных пунктов, в которых проживают клиенты банка.
-- 8 Вывести клиентов, у которых ни на одном счете не осталось средств.
-- 9 Вывести сумма расходов по рублевому счету для каждого клиента.
-- 10 Вывести количество открытых счетов для каждой валюты.
		
--task1--
select * from clients where fname = 'ivanov';
--task2--
select fname, lname, name, city from clients join cities on city = cid where cities.name = 'msc';
--task3--
select count(*) from accounts as acc join currencies as cur on cur.iso=acc.cy 
	where odate > '2004-08-20' and cur.iso_name = 'ru';
--task4--
select acc.aid, count(his.ohid) from (accounts as acc join 
									  (select * from ophistory where odate > '2004-08-01') his
									  on his.aid = acc.aid) group by acc.aid;
--task5--
select hist.ohid, op.name,hist.sum, hist.odate from ((ophistory as hist join accounts as acc on hist.aid=acc.aid) 
	join operations as op on hist.oid= op.oid)
	join currencies as cur on cur.iso=acc.cy
	where cur.iso_name = 'ru';
--task6--
select fname, lname, cl.passid from (select acc.passid as passid, count(*) from clients as cl join accounts as acc on acc.passid=cl.passid
											group by acc.passid) countview
											join clients as cl on countview.passid=cl.passid
											where countview.count > 1;
--task7--
select distinct name from clients as cl join cities on cl.city=cities.cid;
--task8--
select cl.passid, fname, lname from (select passid, sum(balance) from accounts group by passid) acc
					join clients as cl on cl.passid=acc.passid
					where acc.sum = 0;
--task9--
select fname, lname, cl.passid, grouped.sum from (select acc.passid as passid, sum(sum) as sum from (((accounts as acc join ophistory as hist on hist.aid=acc.aid)
					join currencies as curr on acc.cy =curr.iso)
					join operations as op on op.oid=hist.oid)
					where iso_name = 'ru' and op.name='subtract'
				   group by acc.passid) grouped 
				   join clients as cl on cl.passid=grouped.passid;
				   
--task10--
select iso_name, count from (select cy, count(*) from accounts group by cy) grouped 
							join currencies as cur on cur.iso=grouped.cy;


-- 1 Написать процедуру перевода средств с одного счета банка на другой. 
-- В качестве параметров процедуры передаются номера счетов и сумма перевода.
-- Необходимо соответсвующим образом изменить величину остатка на каждом из счетов и добавить записи 
-- в реестр операций для каждого из счетов.

--function1--
create or replace function make_transaction(from_ int, to_ int, sum_ int) returns void as
$$
declare from_balance int;
declare to_balance int;
declare is_closed_from date;
declare is_closed_to date;
declare cy1 int;
declare cy2 int;

BEGIN
select accounts.balance into from_balance from accounts where aid=from_;
select accounts.balance into to_balance from accounts where aid=to_;
select accounts.cdate into is_closed_from from accounts where aid=from_;
select accounts.cdate into is_closed_to from accounts where aid=to_;
select accounts.cy into cy1 from accounts where aid=from_;
select accounts.cy into cy2 from accounts where aid=to_;
case when cy1  != cy2
	then raise exception 'cannot make transaction';
	else
end case;
case 
	when from_balance >= sum_ and is_closed_from is null and is_closed_to is null
	then insert into ophistory(oid, aid, sum, odate) values 
			(1, to_, sum_, current_date),
			(2, from_, sum_, current_date);
 		update accounts set balance = from_balance - sum_ where aid=from_;
 		update accounts set balance = to_balance + sum_ where aid=to_;
	else raise notice 'incorrect operation';
end case;
	
END
$$ LANGUAGE plpgsql;

select * from accounts;
select make_transaction(8, 9, 50);
select * from accounts;
select make_transaction(1, 2, 1500);
select make_transaction(1, 15, 100);
select * from accounts;
select * from ophistory;


-- 2 Написать функцию, вычисляющую кредитный процент для клиента.
-- В качестве параметра функции передается id клиента.
-- Величина процента зависит от срока, в течении которого данный человек является клиентом банка 
-- и ежемесячных посуплений на счета клиента. Начальное значение задается константой в теле функции (например, 9%).
-- Из этого значения вычитается количество полных лет, в течение которых человек является клиентом банка, 
-- умноженное на 0.1; вычисляется среднее отношение дохода к расходу по всем счетам клиента за последние 2 года, 
-- в случае, когда полученная величина больше 1, она умножается на 0.1 и вычитается из значения процента. 
-- Минимальное возможное значение 4%.

--function2--
create or replace function count_percent(cid int) returns float as
$$
declare initial_value float;
declare years int;
declare opendate date;
declare cl_percent float;
declare income int;
declare outcome int;
declare frac float;
begin
select 0.09 into initial_value;
select min(odate) into opendate from accounts where passid=cid;
select extract(year from opendate) into years;
select extract(year from current_date) - years into years;
select initial_value - years * 0.1 into cl_percent;
select sum(sum) into outcome from accounts as acc join ophistory as hist on hist.aid=acc.aid 
					join operations as op on op.oid=hist.oid
					where op.name='subtract' and acc.passid=cid
					and extract(year from hist.odate) >= extract(year from current_date) - 2;
select sum(sum) into income from accounts as acc join ophistory as hist on hist.aid=acc.aid 
					join operations as op on op.oid=hist.oid
					where op.name='add' and acc.passid=cid
					and extract(year from hist.odate) >= extract(year from current_date) - 2;
case 
	when outcome > 0
	then select income / outcome into frac;
	else select 0 into frac;
end case;

case 
	when frac > 1
	then select cl_percent - frac * 0.1 into cl_percent;
	else select cl_percent into cl_percent;
end case;

case
	when cl_percent > 0.04
	then return cl_percent;
	else return 0.04;
end case;

end
$$ LANGUAGE plpgsql;

select count_percent(113);


--  3 Написать функцию, возвращающую список клиентов, у которых в банке открыто несколько счетов,
--  и у которых хотя бы на одном из счетов отрицательный баланс.
--  Возвращаемая таблица состоит из трех столбцов. Первые два – id и ФИО клиента.
--  Третий – строка в формате: № _счета_1 (валюта_счета_1): остаток_на_счете_1; № _счета_2 (валюта_счета_2): остаток_на_счете_2, ...

--function 3--
DROP FUNCTION minus_clients();
create or replace function minus_clients() returns table(cid int, fio text, balance text) as 
$$
begin
create or replace view minus(passid) as
	select acc.passid as passid from accounts as acc
		where acc.balance < 0;

create or replace view minus_all as
	select acc.passid, aid, cy, balance from minus  
						join accounts as acc on acc.passid=minus.passid;
return query
	select f2.passid, accounts, string_agg(fname|| ' ' || lname || ' ' || mname, ',') as fio from 
		(select passid, 
			string_agg(aid || ''|| '(' || iso_name || '):' || f.balance, ',') accounts
			from  (select m1.passid as passid, aid, iso_name, m1.balance 
				  from minus_all as m1 join currencies as cur on cur.iso=m1.cy group by m1.passid, aid, iso_name, m1.balance) as f
					group by passid) f2 join clients as cl on cl.passid=f2.passid group by f2.passid, accounts;

end
$$ LANGUAGE plpgsql;

select * from minus_clients();


-- Создать триггер  на операцию закрытия счета.
-- В случае, когда остаток на счете = 0 позволять закрыть счет.
-- Когда остаток отрицателен выбрасывать исключение и не позволять закрыть счет.
-- Когда остаток положителен и тот же клиент имеет в банке другой открытый счет – 
-- перевести остаток на второй счет, этот закрыть. 
-- Когда остаток положителен и второго открытого счета в нашем банке нет – выкидывать исключение.

--trigger1--
create or replace function on_closing() returns trigger as
$$
declare cl_aid int;
declare acc_num int;
declare sec_acc int;
declare sec_acc_balance int;
declare cl_balance int;
declare cid int;
begin
select aid into cl_aid from accounts where new.cdate is distinct from old.cdate;
select accounts.balance into cl_balance from accounts where accounts.aid=cl_aid;
select passid into cid from accounts where accounts.aid=cl_aid;
select count(*) into acc_num from accounts where accounts.passid=cid;

case 
	when cl_balance = 0
	then return NEW;
	when cl_balance > 0 and acc_num > 1
	then 
		select min(accounts.aid) into sec_acc from accounts where accounts.aid!=cl_aid;
		select accounts.balance into sec_acc_balance from accounts where accounts.aid=sec_acc;
		update accounts set balance = 0 where accounts.aid=cl_aid;
		update accounts set balance = sec_acc_balance + cl_balance where accounts.aid=sec_acc;
		return NEW;
	when cl_balance < 0
	then
		raise exception 'balance is less than zero';
		return OLD;
	else
		raise exception 'balance is more than zero and no second account';
		return OLD;
	
end case;
end
$$ LANGUAGE plpgsql;

create trigger close_account
	before update on accounts
	for each row
		when (new.cdate is distinct from old.cdate)
		execute procedure on_closing();
		
update accounts set cdate = current_date where aid=5;
update accounts set cdate = current_date where aid=22;
update accounts set cdate = current_date where aid=4;
select * from accounts;


-- Создать триггер на добавление новой операции над счетом.
-- В теле триггера изменять остаток на счете в соответствии с добавляемой операцией.

--trigger2--
create or replace function add_op() returns trigger as
$$
declare opid int;
declare opsum int;
declare op_accid int;
declare old_balance int;

begin
select aid into op_accid from ophistory where new.aid = ophistory.aid;
select sum into opsum from ophistory where new.ohid = ophistory.ohid;
select oid into opid from ophistory where new.oid = ophistory.oid;
select balance into old_balance from accounts where aid=op_accid;

case
	when opid = 1
	then 
		update accounts set balance = old_balance + opsum where aid=op_accid;
		return new;
	when opid = 2
	then 
		update accounts set balance = old_balance - opsum where aid=op_accid;
		return new;
	else
		raise exception 'incorrect operation code';
end case;
end 
$$ LANGUAGE plpgsql;
drop trigger make_op on ophistory;
create trigger make_op
	after insert on ophistory
 	referencing new table as new
	for each row
	execute procedure add_op();
	

insert into ophistory(oid, aid, sum, odate) values
 	(1, 1, 100, current_date),
	(2, 1, 300, current_date);
select * from accounts;
select * from ophistory;

insert into ophistory(oid, aid, sum, odate) values
 	(1, 2, 400, current_date);
select * from accounts;
