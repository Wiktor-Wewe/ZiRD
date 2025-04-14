1)
SELECT RANK() OVER (ORDER BY SALARY DESC) AS RANKING, FIRST_NAME, LAST_NAME, SALARY
FROM EMPLOYEES
ORDER BY SALARY DESC 

2) 
SELECT 
    RANK() OVER (ORDER BY SALARY DESC) AS ranking,
    FIRST_NAME,
    LAST_NAME ,
    SALARY,
    SUM(SALARY) OVER () AS SUM_Salary
FROM EMPLOYEES;

3) 
CREATE TABLE sales AS
SELECT * FROM HR.sales;

CREATE TABLE products AS
SELECT * FROM HR.products;

4)
SELECT 
    e.Last_Name,
    pr.PRODUCT_NAME,
    SUM(s.QUANTITY * s.PRICE) OVER (PARTITION BY e.LAST_NAME) AS skumulowana_wartosc_sprzedazy,
    RANK() OVER (ORDER BY s.QUANTITY * s.PRICE DESC) AS ranking_sprzedazy
FROM SALES s
JOIN PRODUCTS pr ON s.PRODUCT_ID = pr.PRODUCT_ID
JOIN EMPLOYEES e  ON s.EMPLOYEE_ID = e.EMPLOYEE_ID;

5)
SELECT 
    e.LAST_NAME ,
    pr.PRODUCT_NAME ,
    s.PRICE  AS cena_produktu,
    COUNT(*) OVER (PARTITION BY s.PRODUCT_ID, s.SALE_DATE) AS liczba_transakcji_dnia,
    SUM(s.QUANTITY * s.PRICE) OVER (PARTITION BY s.PRODUCT_ID, s.SALE_DATE) AS suma_zaplacona_dnia,
    LAG(s.PRICE) OVER (PARTITION BY s.PRODUCT_ID ORDER BY s.SALE_DATE) AS poprzednia_cena,
    LEAD(s.PRICE) OVER (PARTITION BY s.PRODUCT_ID ORDER BY s.SALE_DATE) AS kolejna_cena
FROM SALES s
JOIN PRODUCTS pr ON s.PRODUCT_ID  = pr.PRODUCT_ID 
JOIN EMPLOYEES e ON s.EMPLOYEE_ID = e.EMPLoyee_id;


6)
SELECT 
    p.PRODUCT_NAME,
    s.PRICE AS cena_produktu,
    SUM(s.QUANTITY * s.PRICE) OVER (PARTITION BY EXTRACT(YEAR FROM s.SALE_DATE), EXTRACT(MONTH FROM s.SALE_DATE)) AS suma_miesieczna,
    SUM(s.QUANTITY * s.PRICE) OVER (PARTITION BY EXTRACT(YEAR FROM s.SALE_DATE), EXTRACT(MONTH FROM s.SALE_DATE), s.PRODUCT_ID ORDER BY s.SALE_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS suma_rosnaca_miesieczna
FROM SALES s
JOIN PRODUCTS p ON s.PRODUCT_ID = p.PRODUCT_ID;

7)
SELECT
    p.product_name,
    s.sale_date,
    LAG(s.price) OVER (PARTITION BY p.product_name ORDER BY s.sale_date) AS previous_price,
    s.price AS current_price,
    LEAD(s.price) OVER (PARTITION BY p.product_name ORDER BY s.sale_date) AS next_price,
    (LAG(s.price) OVER (PARTITION BY p.product_name ORDER BY s.sale_date) +
     s.price +
     LEAD(s.price) OVER (PARTITION BY p.product_name ORDER BY s.sale_date)) / 3 AS moving_average
FROM products p
JOIN sales s ON p.product_id = s.product_id;

8)
SELECT
    p.product_name,
    p.product_category,
    RANK() OVER (PARTITION BY p.product_category ORDER BY s.price) AS price_rank,
    DENSE_RANK() OVER (PARTITION BY p.product_category ORDER BY s.price) AS dense_price_rank
FROM products p
JOIN sales s ON p.product_id = s.product_id;

9)
SELECT 
    p.PRODUCT_NAME ,
    (LAG(s.PRICE) OVER (PARTITION BY s.PRODUCT_ID ORDER BY s.SALE_DATE) + 
     s.PRICE + 
     LEAD(s.PRICE) OVER (PARTITION BY s.PRODUCT_ID  ORDER BY s.SALE_DATE)) / 3 AS srednia_kroczaca_cena
FROM sales s
JOIN products p ON s.PRODUCT_ID = p.PRODUCT_ID;

10)
SELECT
    p.product_name,
    p.product_category,
    RANK() OVER (PARTITION BY p.product_category ORDER BY s.price) AS price_rank,
    DENSE_RANK() OVER (PARTITION BY p.product_category ORDER BY s.price) AS dense_price_rank
FROM products p
JOIN sales s ON p.product_id = s.product_id;

11)
SELECT
    sales_data.last_name,
    sales_data.product_name,
    sales_data.sale_date,
    sales_data.cumulative_sales_value,
    RANK() OVER (ORDER BY sales_data.cumulative_sales_value DESC) AS global_sales_rank
FROM (
    SELECT
        e.last_name,
        p.product_name,
        s.sale_date,
        s.employee_id,
        s.sale_id,
        SUM(s.sale_id) OVER (PARTITION BY s.employee_id, p.product_name ORDER BY s.sale_date) AS cumulative_sales_value
    FROM
        employees e
    JOIN sales s ON e.employee_id = s.employee_id
    JOIN products p ON s.product_id = p.product_id
) sales_data;

12)
SELECT
    e.first_name,
    e.last_name,
    j.job_title
FROM sales s
JOIN employees e ON s.employee_id = e.employee_id
JOIN jobs j ON e.job_id = j.job_id 
JOIN products p ON s.product_id = p.product_id
GROUP BY e.first_name, e.last_name, j.job_title;  