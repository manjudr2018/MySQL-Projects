use mdr;
Drop table swiggy;
Create table Swiggy
(ID int, Cust_ID varchar(20), Order_ID int, Partner_code int,
 outlet varchar(30), bill_amount int, order_date date, comments varchar(30)
 );
 
 Insert into swiggy
 values
(1, 'SW1005', 700, 50, 'KFC', 753, '2021-10-10', 'Door Locked'),
(2, 'SW1006', 710, 59, 'Pizza hut', 1496, '2021-09-01', 'In-time delivery'),
(3, 'SW1005', 720, 59, 'Dominos', 990, '2021-12-10', ' '),
(4, 'SW1005', 707, 50, 'Pizza hut', 2475, '2021-12-11', ' '),
(5, 'SW1006', 770, 59, 'KFC', 1250, '2021-11-17', 'No Response'),
(6, 'SW1020', 1000, 119, 'pizza hut', 1400, '2021-11-18', 'In-time delivery'),
(7, 'SW1035', 1079, 135, 'Dominos', 1750, '2021-11-19', ' '),
(8, 'SW1020', 1083, 59, 'KFC', 1250, '2021-11-20', ' '),
(11, 'SW1020', 1100, 150, 'Pizza hut', 1950, '2021-12-24', 'Late delivery'),
(9, 'SW1035', 1095, 119, 'Pizza hut', 1270, '2021-11-21', 'Late delivery'),
(10, 'SW1005', 729, 135, 'KFC', 1000, '2021-09-10', 'Delivered'),
(1, 'SW1005', 700, 50, 'KFC', 753, '2021-10-10', 'Door Locked'),
(2, 'SW1006', 710, 59, 'Pizza hut', 1496, '2021-09-01', 'In-time delivery'),
(3, 'SW1005', 720, 59, 'Dominos', 990, '2021-12-10', ' '),
(4, 'SW1005', 707, 50, 'Pizza hut', 2475, '2021-12-11', ' ');

#Q1: Find the count of duplicate rows in the swiggy table............................................................................
Select distinct Id, Cust_ID, order_Id, count(cust_Id) as Records_count from Swiggy
Group by ID, Cust_ID, order_Id
having Records_count>1;

#Q2: Remove Duplicate records from the table...............................................................................................
Create temporary table ab 
as(select distinct Id, Cust_ID, order_Id, partner_code, outlet, bill_amount, order_date, comments from Swiggy
);
drop table swiggy;

Create table Swiggy as (select * from ab);
select * from swiggy;
drop table ab;

#Q3: Print record from now number 4 to 9......................................................................................................
Select * from Swiggy
limit 3,6;

#Q4: Find the latest order place by customers. Refer to the output below..........................................................
with xy
as(Select Cust_Id, Outlet, order_date, Rank() over(partition by Cust_Id order by Order_date desc) as Rankorder from swiggy
group by Cust_Id, Outlet, order_date)
select * from xy having Rankorder<2;


#Q5: ........................................................................................................................
Set sql_safe_updates= 0;
Update swiggy
set comments = 'No Issues'
where comments = ' ';
Select * from Swiggy;
select order_Id, Partner_code, Order_date, Comments from swiggy;


#Q6................................................................................................................................
Select a.outlet, a.Order_cnt, a.total_sal,
		@Cum_cnt:=@Cum_cnt+a.order_cnt as Cummulative_cnt,
        @Cum_sal:=@Cum_sal+a.total_sal as Cummulative_sal
from
		(Select Outlet, count(Id) as order_cnt , sum(bill_amount) as total_sal from swiggy
		 group by outlet
         order by order_cnt asc) as a
		 join
		 (select @Cum_cnt:=0, @Cum_Sal:=0) as b;
         
#Q7.................................................................................................................................

Select d.Cust_ID, Coalesce(a.KFC, 0) as KFC, Coalesce(c.Dominos, 0) as Dominos, Coalesce(b.Pizza_hut, 0) as Pizza_hut
From
(Select distinct Cust_Id from swiggy) as d
left join
(Select Cust_Id, COUNT(Cust_Id) as KFC from swiggy
where Outlet ='KFC'
group by Cust_Id) as a
on d.Cust_Id = a.Cust_Id
left join
(Select Cust_Id, COUNT(Cust_Id) as Pizza_hut from swiggy
where Outlet ='Pizza hut'
group by Cust_Id) as b
on d.Cust_Id = b.Cust_Id
left join
(Select Cust_Id, COUNT(Cust_Id) as Dominos from swiggy
where Outlet ='Dominos'
group by Cust_Id) as c
on d.Cust_Id = c.Cust_Id;

#Q8................................................................................................................................

Select d.Cust_ID, Coalesce(a.KFC, 0) as KFC, Coalesce(c.Dominos, 0) as Dominos, Coalesce(b.Pizza_hut, 0) as Pizza_hut
From
(Select distinct Cust_Id from swiggy) as d
left join
(Select Cust_Id, sum(bill_amount) as KFC from swiggy
where Outlet ='KFC'
group by Cust_Id) as a
on d.Cust_Id = a.Cust_Id
left join
(Select Cust_Id, sum(bill_amount) as Pizza_hut from swiggy
where Outlet ='Pizza hut'
group by Cust_Id) as b
on d.Cust_Id = b.Cust_Id
left join
(Select Cust_Id, sum(bill_amount) as Dominos from swiggy
where Outlet ='Dominos'
group by Cust_Id) as c
on d.Cust_Id = c.Cust_Id;



