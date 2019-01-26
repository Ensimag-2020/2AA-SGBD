-- Q1: Donner la liste des noms d'employés
SELECT ename FROM EMP;

-- Q2: Donner la liste des noms et date d'embauche des employés du département 20
SELECT ename FROM EMP WHERE DEPTNO=20;

-- Q3: Donner la somme des salaires donnés dans l'entreprise.
SELECT SUM(SAL) FROM EMP;

-- Q4: Donner la liste des employés (nom, poste et salaire) qui gagnent plus de 2800€ et qui sont manager.
SELECT ENAME, JOB, SAL FROM EMP WHERE SAL > 2800 AND JOB='MANAGER';

-- Q5: Donner la liste des employés dont le département est situé à Dallas.
SELECT E.ENAME, E.JOB, E.SAL FROM EMP E, DEPT D WHERE D.LOC='DALLAS' AND D.DEPTNO = E.DEPTNO;

-- Q6: Donner la liste des employés du département 30 (nom, poste et salaire), triée sur le salaire par ordre croissant.
SELECT ENAME, JOB, SAL FROM EMP WHERE DEPTNO='30' ORDER BY SAL ASC;

-- Q7: Donnez l'ensemble des différents postes de l’entreprise (tous distincts).
SELECT DISTINCT JOB FROM EMP;

-- Q8: Donnez la liste des employés dont le nom commence par M, et dont le salaire est supérieur ou égal à 1290 €.
SELECT ENAME, JOB, SAL FROM EMP WHERE ENAME LIKE 'M%' AND SAL >= 1290;

-- Q9: Donner la situation du département dans lequel travaille l'employé de nom Allen.
SELECT D.LOC FROM DEPT D, EMP E WHERE E.ENAME='ALLEN' AND D.DEPTNO=E.DEPTNO;

-- Q10: Donner la liste des départements, qui possèdent des postes CLERK, SALESMAN ou ANALYST.
SELECT D.DNAME FROM DEPT D, EMP E WHERE D.DEPTNO=E.DEPTNO AND JOB IN ('CLERK', 'SALESMAN', 'ANALYST') GROUP BY D.DNAME;

-- Q11: Donner la liste des managers (la valeur associée à sa fonction est MANAGER), dont les subordonnés perçoivent une commission.
SELECT DISTINCT MANAGERS.ENAME FROM EMP SUBORDINATES, EMP MANAGERS WHERE SUBORDINATES.MGR = MANAGERS.EMPNO AND SUBORDINATES.COMM IS NOT NULL;

-- Q12: Donner la liste des employés dont le département est situé à DALLAS ou CHICAGO, et dont le salaire est supérieur à 1000.
SELECT E.ENAME FROM DEPT D, EMP E WHERE D.DEPTNO=E.DEPTNO AND E.SAL > 1000 AND D.LOC IN ('CHICAGO', 'DALLAS');

-- Q13: Donner un récapitulatif, qui pour chaque nom de département, donne le nom des postes, la somme des salaires dépensés pour chaque poste, le nombre d'employés sur chaque poste dans ce département, et la moyenne des salaires sur chaque poste dans ce département. Dans le récapitulatif, ne doivent apparaître que les départements qui ont plus de deux employés sur un type de poste donné.
SELECT DISTINCT D.DNAME, E.JOB, SUM(E.SAL), AVG(E.SAL) FROM DEPT D, EMP E WHERE D.DEPTNO=E.DEPTNO GROUP BY D.DNAME, E.JOB HAVING count(E.EMPNO) > 2;

-- Q14: Pour chaque employé, donner le nom, le salaire, l'échelle de salaire, le nom de son supérieur hiérarchique direct, le numéro du département, et la ville du département. La liste doit être ordonnée sur le salaire.
SELECT SUB.ENAME, SUB.SAL AS SAL, G.GRADE, MGR.ENAME as MANAGER, D.LOC
    FROM EMP SUB, EMP MGR, DEPT D, SALGRADE G
    WHERE SUB.DEPTNO=D.DEPTNO AND SUB.MGR=MGR.EMPNO AND SUB.SAL <= G.HISAL AND SUB.SAL > G.LOSAL
    UNION
        SELECT SUB.ENAME, SUB.SAL AS SAL, G.GRADE, SUB.ENAME, D.LOC
        FROM EMP SUB, EMP MGR, DEPT D, SALGRADE G
        WHERE SUB.DEPTNO=D.DEPTNO AND SUB.MGR IS NULL AND SUB.SAL <= G.HISAL AND SUB.SAL > G.LOSAL
ORDER BY SAL;

-- Q15: Pour chaque département, calculer la moyenne des salaires.
SELECT AVG(SAL), DEPTNO FROM EMP GROUP BY DEPTNO
    UNION 
    SELECT 0, DEPTNO FROM DEPT WHERE DEPTNO NOT IN (SELECT DISTINCT DEPTNO FROM EMP);

-- Q16: Pour chaque employé donner la proportion de la commission et du salaire (par rapport au montant total perçu).
SELECT ENAME, COALESCE(COMM, 0)/(COALESCE(COMM, 0) + SAL) AS COMMPROP FROM EMP;

-- Q17: Quels sont les départements qui coûtent le plus cher, et le moins cher en terme de salaire ? On donnera le résultat en une seule requête.
SELECT DEPTNO, SUM(SAL) FROM EMP GROUP BY DEPTNO HAVING SUM(SAL) = (SELECT MAX(SUM(SAL)) FROM EMP GROUP BY DEPTNO) OR SUM(SAL) = (SELECT MIN(SUM(SAL)) FROM EMP GROUP BY DEPTNO);

-- Q18: Donner la liste des numéros de département qui ont plus de 3 employés, mais qui ne sont pas situés à Chicago.
SELECT D.DEPTNO FROM EMP E, DEPT D WHERE D.DEPTNO = E.DEPTNO AND D.LOC != 'CHICAGO' GROUP BY D.DEPTNO HAVING count(E.EMPNO) >= 3;

-- Q19: Donner la liste des numéros de départements qui n'ont pas d'employés
SELECT DEPTNO FROM DEPT WHERE DEPTNO NOT IN (SELECT DISTINCT DEPTNO FROM EMP);

-- Q20: Quel est le département qui emploie le plus de salariés ?
SELECT DEPTNO, COUNT(EMPNO) FROM EMP GROUP BY DEPTNO HAVING COUNT(EMPNO) = (SELECT MAX(COUNT(EMPNO)) FROM EMP GROUP BY DEPTNO);SELECT D.DEPTNO FROM EMP E, DEPT D WHERE D.DEPTNO = E.DEPTNO AND D.LOC != 'CHICAGO' GROUP BY D.DEPTNO HAVING count(E.EMPNO) >= 3;SELECT D.DEPTNO FROM EMP E, DEPT D WHERE D.DEPTNO = E.DEPTNO AND D.LOC != 'CHICAGO' GROUP BY D.DEPTNO HAVING count(E.EMPNO) >= 3;

-- Solution plus simple
SELECT DEPT.DEPTNO, COUNT(EMP.EMPNO)
FROM DEPT,
     EMP
WHERE DEPT.DEPTNO = EMP.DEPTNO
GROUP BY EMP.DEPTNO
HAVING COUNT(EMP.EMPNO) >= ALL (SELECT COUNT(EMP.EMPNO)
                                     FROM DEPT,
                                          EMP
                                     WHERE DEPT.DEPTNO = EMP.DEPTNO
                                     GROUP BY EMP.DEPTNO)
                                                                                       
