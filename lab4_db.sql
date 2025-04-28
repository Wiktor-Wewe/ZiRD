zad 1:
CREATE VIEW v_wysokie_pensje AS
SELECT * 
FROM employees
WHERE salary > 6000;

zad 2:
DROP VIEW v_wysokie_pensje;

CREATE VIEW v_wysokie_pensje AS
SELECT * 
FROM employees
WHERE salary > 12000;

zad 3:
DROP VIEW v_wysokie_pensje;

zad 4:
CREATE VIEW v_finance_employees AS
SELECT e.employee_id, e.last_name, e.first_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'Finance';

zad 5:
CREATE VIEW v_pracownicy_5k_12k AS
SELECT employee_id, last_name, first_name, salary, job_id, email, hire_date
FROM employees
WHERE salary BETWEEN 5000 AND 12000;

zad 6:
INSERT INTO v_pracownicy_5k_12k (employee_id, last_name, first_name, salary, job_id, email, hire_date)
VALUES (999, 'Kowalski', 'Jan', 7000, 'SA_REP', 'jan.kowalski@example.com', SYSDATE);

UPDATE v_pracownicy_5k_12k
SET salary = 8000
WHERE employee_id = 999;

DELETE FROM v_pracownicy_5k_12k
WHERE employee_id = 999;

zad 7:
CREATE VIEW v_duze_dzialy AS
SELECT 
    d.department_id,
    d.department_name,
    COUNT(e.employee_id) AS liczba_pracownikow,
    AVG(e.salary) AS srednia_pensja,
    MAX(e.salary) AS maks_pensja
FROM departments d
JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(e.employee_id) >= 4;

zad 9:
CREATE OR REPLACE VIEW v_pracownicy_5k_12k_check AS
SELECT employee_id, last_name, first_name, salary
FROM employees
WHERE salary BETWEEN 5000 AND 12000
WITH CHECK OPTION;

zad 10:
CREATE VIEW v_najlepiej_oplacani AS
SELECT *
FROM (
    SELECT employee_id, first_name, last_name, salary
    FROM employees
    ORDER BY salary DESC
)
WHERE ROWNUM <= 10;