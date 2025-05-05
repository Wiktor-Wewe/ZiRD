zad 1:
DECLARE
    numer_max DEPARTMENTS.DEPARTMENT_ID%TYPE;
    nazwa_nowego_departamentu DEPARTMENTS.DEPARTMENT_NAME%TYPE := 'EDUCATION';
BEGIN
    SELECT MAX(DEPARTMENT_ID) INTO numer_max FROM DEPARTMENTS;
    
    INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME)
    VALUES (numer_max + 10, nazwa_nowego_departamentu);
    
    DBMS_OUTPUT.PUT_LINE('Dodano departament nr ' || (numer_max + 10));
END;

zad 2:
DECLARE
    numer_max DEPARTMENTS.DEPARTMENT_ID%TYPE;
    nazwa_nowego_departamentu DEPARTMENTS.DEPARTMENT_NAME%TYPE := 'EDUCATION';
BEGIN
    SELECT MAX(DEPARTMENT_ID) INTO numer_max FROM DEPARTMENTS;

    INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME, LOCATION_ID)
    VALUES (numer_max + 10, nazwa_nowego_departamentu, 3000);
    
    DBMS_OUTPUT.PUT_LINE('Dodano departament z LOCATION_ID 3000');
END;

zad 3:
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE nowa';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;

CREATE TABLE nowa (
    tekst VARCHAR2(50)
);

DECLARE
    i NUMBER := 1;
BEGIN
    WHILE i <= 10 LOOP
        IF i NOT IN (4,6) THEN
            INSERT INTO nowa VALUES (TO_CHAR(i));
        END IF;
        i := i + 1;
    END LOOP;
END;

zad 4:
DECLARE
    kraj COUNTRIES%ROWTYPE;
BEGIN
    SELECT * INTO kraj FROM COUNTRIES WHERE COUNTRY_ID = 'CA';

    DBMS_OUTPUT.PUT_LINE('Kraj: ' || kraj.COUNTRY_NAME);
    DBMS_OUTPUT.PUT_LINE('Region: ' || kraj.REGION_ID);
END;

zad 5:
DECLARE
    CURSOR c_pracownicy IS
        SELECT LAST_NAME, SALARY FROM EMPLOYEES WHERE DEPARTMENT_ID = 50;
    v_pracownik c_pracownicy%ROWTYPE;
BEGIN
    OPEN c_pracownicy;
    LOOP
        FETCH c_pracownicy INTO v_pracownik;
        EXIT WHEN c_pracownicy%NOTFOUND;
        
        IF v_pracownik.SALARY > 3100 THEN
            DBMS_OUTPUT.PUT_LINE(v_pracownik.LAST_NAME || ' - nie dawać podwyżki');
        ELSE
            DBMS_OUTPUT.PUT_LINE(v_pracownik.LAST_NAME || ' - dać podwyżkę');
        END IF;
    END LOOP;
    CLOSE c_pracownicy;
END;

zad 6:
DECLARE
  CURSOR pracownicy_cursor(min_sal NUMBER, max_sal NUMBER, cz_imienia VARCHAR2) IS
    SELECT first_name, last_name, salary
    FROM employees
    WHERE salary BETWEEN min_sal AND max_sal
      AND LOWER(first_name) LIKE '%' || LOWER(cz_imienia) || '%';
    
  rekord pracownicy_cursor%ROWTYPE;
BEGIN
  DBMS_OUTPUT.PUT_LINE('widełki 1000-5000, imię zawiera "a":');
  FOR rekord IN pracownicy_cursor(1000, 5000, 'a') LOOP
    DBMS_OUTPUT.PUT_LINE(rekord.first_name || ' ' || rekord.last_name || ' - ' || rekord.salary);
  END LOOP;
  
  DBMS_OUTPUT.PUT_LINE('widełki 5000-20000, imię zawiera "u":');
  FOR rekord IN pracownicy_cursor(5000, 20000, 'u') LOOP
    DBMS_OUTPUT.PUT_LINE(rekord.first_name || ' ' || rekord.last_name || ' - ' || rekord.salary);
  END LOOP;
END;

zad 9a:
CREATE OR REPLACE PROCEDURE dodaj_job (
  p_job_id JOBS.job_id%TYPE,
  p_job_title JOBS.job_title%TYPE
) AS
BEGIN
  INSERT INTO jobs(job_id, job_title, min_salary, max_salary)
  VALUES (p_job_id, p_job_title, NULL, NULL);
  DBMS_OUTPUT.PUT_LINE('Added new job: ' || p_job_id);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;

zad 9b:
CREATE OR REPLACE PROCEDURE zmien_job_title (
  p_job_id JOBS.job_id%TYPE,
  p_nowy_title JOBS.job_title%TYPE
) AS
  v_liczba NUMBER;
BEGIN
  UPDATE jobs SET job_title = p_nowy_title WHERE job_id = p_job_id;
  v_liczba := SQL%ROWCOUNT;
  IF v_liczba = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'No job was updated');
  ELSE
    DBMS_OUTPUT.PUT_LINE('job_title was change to: ' || p_nowy_title);
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;

zad 9c:
CREATE OR REPLACE PROCEDURE usun_job (
  p_job_id JOBS.job_id%TYPE
) AS
  v_liczba NUMBER;
BEGIN
  DELETE FROM jobs WHERE job_id = p_job_id;
  v_liczba := SQL%ROWCOUNT;
  
  IF v_liczba = 0 THEN
    RAISE_APPLICATION_ERROR(-20002, 'No job was deleted');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Deleted job:' || p_job_id);
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error:' || SQLERRM);
END;

zad 9d:
CREATE OR REPLACE PROCEDURE pobierz_dane_pracownika (
  p_employee_id EMPLOYEES.employee_id%TYPE,
  p_salary OUT EMPLOYEES.salary%TYPE,
  p_last_name OUT EMPLOYEES.last_name%TYPE
) AS
BEGIN
  SELECT salary, last_name
  INTO p_salary, p_last_name
  FROM employees
  WHERE employee_id = p_employee_id;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Unable to find employee');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error:' || SQLERRM);
END;