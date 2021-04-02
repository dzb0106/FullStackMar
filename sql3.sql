-- Zhubo Deng
-- 04/02/21

-- 1. List all cities that have both Employees and Customers.
select distinct e.City
from Employees e
join Customers c
on e.City = c.City

-- 2. List all cities that have Customers but no Employee.
-- a. Use sub-query
select distinct c.City
from Customers c
where c.City not in (
	select City from Employees e)
-- b. Do not use sub-query
select distinct c.City
from Customers c
left join Employees e
on c.City = e.City
where e.city is null

-- 3. List all products and their total order quantities throughout all orders.
select ProductID, sum(Quantity)as 'Total Orders'
from [Order Details]
group by ProductID

-- 4. List all Customer Cities and total products ordered by that city.
select c.City, sum(od.Quantity)as 'Total Orders'
from Customers c
join Orders o
on c.customerid = o.CustomerID
join [Order Details] od
on o.OrderID = od.OrderID
group by c.City

-- 5. List all Customer Cities that have at least two customers.
-- a. Use union
-- b. Use sub-query and no union
select distinct c.City
from Customers c
where city in (
	select city
	from Customers
	group by city
	having 1<count(CustomerID))

-- 6. List all Customer Cities that have ordered at least two different kinds of products.
select distinct c.City
from Customers c
where city in (
	select ShipCity
    from Orders o
	join [Order Details] od
	on o.OrderID = od.OrderID
	group by ShipCity
	having count(ProductID) > 1)

-- 7. List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.
select distinct c.CustomerID, c.City, o.ShipCity
from Customers c
join Orders o
on c.CustomerID = o.CustomerID
where c.city != o.ShipCity

-- 8. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.


-- 9. List all cities that have never ordered something but we have employees there.
-- a. Use sub-query
select distinct City
from Employees
where city not in (
	select ShipCity from Orders where ShipCity is not null)
-- b. Do not use sub-query
select distinct City
from Employees
where City is not null
except (
	select ShipCity from Orders where ShipCity is not null)

-- 10. List one city, if exists, that is the city from where the employee sold most orders 
-- (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join  sub-query)
select (select top 1 City
        from Orders o
        join [Order Details] od
        on o.OrderID=od.OrderID
        join Employees e
        on e.EmployeeID = o.EmployeeID
        group by e.EmployeeID,e.City
        order by COUNT(*) desc) as MostOrderedCity,

        (select top 1 City from Orders o
        join [Order Details] od
        on o.OrderID=od.OrderID
        join Employees e
        on e.EmployeeID = o.EmployeeID
        group by e.EmployeeID,e.City
        order by sum(Quantity) desc) as MostQunatitySoldCity


-- 11. How do you remove the duplicates record of a table?
-- a. use group by and count(), if count()>1 then delete the rows using sub query
-- b. write a cte that uses ROW_NUMBER() to find the duplicate rows in the specified columns. Then DELETE FROM cte
--    to delete all the duplicate rows but keeps only one occurrence of each duplicate group.

-- 12. Sample table to be used for solutions below- 
-- Employee ( empid integer, mgrid integer, deptid integer, salary integer) 
-- Dept (deptid integer, deptname text)
-- Find employees who do not manage anybody.
select e1.empid
from Employee e1
left join Employee e2
on e1.empid = e2.mgrid
where e2.mgrid is null

-- 13. Find departments that have maximum number of employees. (solution should consider scenario having more than 1 departments that have maximum number of employees). Result should only have - deptname, count of employees sorted by deptname.
select dt.deptname
from (select d.deptname, count(e.empid) as totalEMP,
       dense_rank() OVER (ORDER BY count(e.empid) DESC)as rnk
        from Dept d
        join Employee e
        on d.deptid = e.deptid
        group by d.deptname)dt
where dt.rnk = 1

-- 14. Find top 3 employees (salary based) in every department. Result should have deptname, empid, salary sorted by deptname and then employee with high to low salary.
select top 3 deptname,empid,salary
from employee e
join dep d
on e.deptid=d.deptid
order by salary,deptname,empid desc

-- GOOD LUCK.


