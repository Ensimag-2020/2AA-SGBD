------ PART 1: ATOMICITE
---- EXO 1
-- Creation de table
CREATE TABLE COMPTES
(
  NC    int PRIMARY KEY,
  Nom   varchar(10),
  Solde decimal(9, 2) CHECK ( Solde >= 0 )
);

-- List all accounts
SELECT *
FROM COMPTES;

--
INSERT INTO COMPTES
VALUES ('2', 'Paul', '342.45');

-- Somme des soldes de tous les comptes
SELECT SUM(Solde)
FROM COMPTES;

-- Rollback;
rollback;
-- La somme devient nulle comme il n'existe plus de compte dans la table


---- EXO 2
-- Insertion de comptes Pierre
INSERT INTO COMPTES
VALUES ('3', 'Pierre', '128.91');
INSERT INTO COMPTES
VALUES ('4', 'Pierre', '428.91');

-- Commit
commit;

-- Insertion de comptes Paul
INSERT INTO COMPTES
VALUES ('1', 'Paul', '387.45');
INSERT INTO COMPTES
VALUES ('2', 'Paul', '923.41');

-- Somme des soldes de tous les comptes
SELECT SUM(Solde)
FROM COMPTES;

-- Rollback;
rollback;
-- La somme du solde devient égale à celle avant l'ajout des comptes de Paul


---- EXO 3
-- Autocommit activé dans Tx: Manual -> Auto

-- Insertion des comptes de Jacques
INSERT INTO COMPTES
VALUES ('5', 'Jacques', '637.15');
INSERT INTO COMPTES
VALUES ('6', 'Jacques', '821.41');

-- Somme des soldes de tous les comptes
SELECT SUM(Solde)
FROM COMPTES;

-- Rollback
rollback;
-- La somme des soldes des comptes reste inchangée comme à chaque transaction, un commit est effectué

-- Désactive Autocommit

-- EXO 4
-- Insertion des comptes de Jean
INSERT INTO COMPTES
VALUES ('7', 'Jean', '82.12');
INSERT INTO COMPTES
VALUES ('8', 'Jean', '800');

-- Savepoint
savepoint DeuxInserts;

INSERT INTO COMPTES
VALUES ('9', 'Jean', '352.52');
INSERT INTO COMPTES
VALUES ('10', 'Jean', '213.02');

-- Somme des soldes de Jean
SELECT SUM(Solde)
FROM COMPTES
WHERE Nom = 'Jean';

-- Rollback to DeuxInserts
rollback to DeuxInserts;
-- Le rollback nous fait revenir vers l'état apres le savepoint, soit avant l'ajouté des deux derniers comptes

-- Rollback classic
rollback ;
-- Les comptes de Jean ont été supprimés, rip monnies


------ PART 2 : COHERENCE
---- Exo 1
-- Ajout des comptes de Clawdio et Honriz
INSERT INTO COMPTES
VALUES('11', 'Claude', '100');
INSERT INTO COMPTES
VALUES('12', 'Henri', '200');

-- On peut incrementer de 50
UPDATE COMPTES SET Solde=Solde+50 WHERE Nom='Henri';
-- On peut pas decrementer de 150 (devient < 0) à cause de la contrainte
UPDATE COMPTES SET Solde=Solde-150 WHERE Nom='Claude';

-- Le solde de Claude reste le meme, celui de Henri incrementé de 50

-- Rollback
rollback ;

-- Les comptes de Clawdio et Henriz sont supprimés

-- Commit
commit;



------ PART 3: ISOLATION
---- Exo 1
DELETE FROM COMPTES WHERE Nom='Jacques';

-- Commit apres l'ajout de 10k dans S2
commit;

-- Jacques n'est plus dans la table apres le commit

-- Les 10k apparaissent dans S1 apres un commit dans S2


---- EXO 2 SERIALIZABLE
SELECT SUM(SOLDE)
FROM COMPTES;

-- Commit
commit;

INSERT INTO COMPTES
VALUES('14', 'Paul', '1000');


commit;

savepoint preDeadlock1;

---- EXO 3 INTERBLOCAGE
UPDATE COMPTES SET Solde = Solde + 100 WHERE Nom='Paul';

UPDATE COMPTES SET Solde = Solde - 100 WHERE Nom='Pierre';

commit;