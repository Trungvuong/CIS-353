
-- File: companyDML-b-solution
-- SQL/DML HOMEWORK (on the COMPANY database)
/*
Every query is worth 2 point. There is no partial credit for a
partially working query - think of this hwk as a large program and each query is a small part of the program.
--
IMPORTANT SPECIFICATIONS
--
(A)
-- Download the script file company.sql and use it to create your COMPANY database.
-- Dowlnoad the file companyDBinstance.pdf; it is provided for your convenience when checking the results of your queries.
(B)
Implement the queries below by ***editing this file*** to include
your name and your SQL code in the indicated places.
--
(C)
IMPORTANT:
-- Don't use views
-- Don't use inline queries in the FROM clause - see our class notes.
--
(D)
After you have written the SQL code in the appropriate places:
** Run this file (from the command line in sqlplus).
** Print the resulting spooled file (companyDML-b.out) and submit the printout in class on the due date.
--
**** Note: you can use Apex to develop the individual queries. However, you ***MUST*** run this file from the command line as just explained above and then submit a printout of the spooled file. Submitting a printout of the webpage resulting from Apex will *NOT* be accepted.
--
*/
-- Please don't remove the SET ECHO command below.
SPOOL companyDML-b.out
SET ECHO ON
-- ------------------------------------------------------------
--
-- Name: <Trungvuong Pham>
--
-- -------------------------------------------------------------
--
-- NULL AND SUBSTRINGS -------------------------------
--
/*(10B)
Find the ssn and last name of every employee whose ssn contains two consecutive 8's, and has a supervisor. Sort the results by ssn.
*/
SELECT ssn, lname
FROM employee
WHERE ssn LIKE '%88%' and
      super_ssn IS NOT NULL;
-- JOINING 3 TABLES ------------------------------
--
/*(11B)
For every employee who works for more than 20 hours on any project that is controlled by the research department: Find the ssn, project number,  and number of hours. Sort the results by ssn.
*/
SELECT w.essn, p.pnumber, w.hours
FROM department d, works_on w, project p
WHERE w.hours > 20 AND
      w.pno = p.pnumber AND
      p.dnum = d.dnumber AND
      d.dname = 'Research'
ORDER BY w.essn;
-- JOINING 3 TABLES ---------------------------
--
/*(12B)
Write a query that consists of one block only.
For every employee who works less than 10 hours on any project that is controlled by the department he works for: Find the employee's lname, his department number, project number, the number of the department controlling it, and the number of hours he works on that project. Sort the results by lname.
*/
SELECT e.lname, e.dno, p.pnumber, p.dnum, w.hours
FROM employee e, works_on w, project p
WHERE e.ssn = w.essn AND
      w.hours < 10 AND
      w.pno = p.pnumber AND
      e.dno = p.dnum
ORDER BY e.lname;
-- JOINING 4 TABLES -------------------------
--
/*(13B)
For every employee who works on any project that is located in Houston: Find the employees ssn and lname, and the names of his/her dependent(s) and their relationship(s) to the employee. Notice that there will be one row per qualyfing dependent. Sort the results by employee lname.
*/
-- <<< Your SQL code goes here >>>
SELECT DISTINCT e.ssn, e.lname, dp.dependent_name, dp.relationship
FROM employee e, dependent dp, project p, works_on w
WHERE e.ssn = dp.essn AND
      e.ssn = w.essn AND
      w.pno = p.pnumber AND
      p.plocation = 'Houston'
ORDER BY e.lname;
-- SELF JOIN -------------------------------------------
--
/*(14B)
Write a query that consists of one block only.
For every employee who works for a department that is different from his supervisor's department: Find his ssn, lname, department number; and his supervisor's ssn, lname, and department number. Sort the results by ssn.
*/
-- <<< Your SQL code goes here >>>
SELECT DISTINCT e.ssn, e.lname, e.dno, s.ssn, s.lname, s.dno
FROM employee e, employee S
WHERE e.super_ssn = s.ssn AND
      e.dno <> s.dno
ORDER BY e.ssn;
-- USING MORE THAN ONE RANGE VARIABLE ON ONE TABLE -------------------
--
/*(15B)
Find pairs of employee lname's such that the two employees in the pair work on the same project for the same number of hours. List every pair once only. Sort the result by the lname in the left column in the result.
*/
-- <<< Your SQL code goes here >>>
SELECT e1.lname, e2.lname
FROM employee e1, employee e2, works_on w1, works_on w2
WHERE e1.ssn = w1.essn AND
      e2.ssn = w2.essn AND
      w1.pno = w2.pno AND
      w1.hours = w2.hours AND
      e1.ssn > e2.ssn
ORDER BY e1.lname;
/*(16B)
For every employee who has more than one dependent: Find the ssn, lname, and number of dependents. Sort the result by lname
*/
-- <<< Your SQL code goes here >>>
SELECT e.ssn, e.lname,COUNT(*)
FROM employee e, dependent dp
WHERE e.ssn = dp.essn
GROUP BY e.ssn, e.lname
HAVING COUNT(*) > 1
ORDER BY e.lname;
/*(17B)
For every project that has more than 2 employees working on and the total hours worked on it is less than 40: Find the project number, project name, number of employees working on it, and the total number of hours worked by all employees on that project. Sort the results by project number.
*/
-- <<< Your SQL code goes here >>>
SELECT p.pnumber, p.pname, COUNT(*), SUM (w.hours)
FROM project p, works_on w
WHERE w.pno = p.pnumber
GROUP BY p.pnumber, p.pname
HAVING COUNT(*) > 2 AND SUM(w.hours) < 40
ORDER BY p.pnumber;
-- CORRELATED SUBQUERY --------------------------------
--
/*(18B)
For every employee whose salary is above the average salary in his department: Find the dno, ssn, lname, and salary. Sort the results by department number.
*/
-- <<< Your SQL code goes here >>>
SELECT e1.dno, e1.ssn, e1.lname, e1.salary
FROM employee e1
WHERE e1.salary >(SELECT AVG(e2.salary)
      FROM employee e2
      WHERE e1.dno = e2.dno)
ORDER BY e1.dno;
-- CORRELATED SUBQUERY -------------------------------
--
/*(19B)
For every employee who works for the research department but does not work on any one project for more than 20 hours: Find the ssn and lname. Sort the results by lname
*/
-- <<< Your SQL code goes here >>>
SELECT e.ssn, e.lname
FROM employee e, Department d
WHERE e.dno = d.dnumber AND
      d.dname = 'Research' AND
      e.ssn NOT IN(SELECT w.essn
            FROM works_on w
            WHERE e.ssn = w.essn AND
                  w.hours > 20)
ORDER BY e.lname;
-- DIVISION ---------------------------------------------
--
/*(20B) Hint: This is a DIVISION query
For every employee who works on every project that is controlled by department 4: Find the ssn and lname. Sort the results by lname
*/
-- <<< Your SQL code goes here >>>
SELECT e.ssn, e.lname
FROM employee e
WHERE NOT EXISTS (
      (SELECT p.pnumber
        FROM project P
        WHERE p.dnum = 4)
        MINUS
        (SELECT w.pno
          FROM works_on w
          WHERE e.ssn = w.essn))
ORDER BY e.lname;
SET ECHO OFF
SPOOL OFF
