------ PART 3
---- Exo 1

SELECT *
FROM COMPTES;

-- Les comptes ne sont supprimés que sur S1

UPDATE COMPTES
SET Solde=Solde + 10000;

-- Jacques n'est plus dans la table apres le commit

-- Commit
commit;


---- EXO 2 SERIALIZABLE
-- Passage en mode Serializable
INSERT INTO COMPTES
VALUES ('13', 'Paul', '500');

-- Commit
commit;

-- Calcul de somme des soldes
SELECT SUM(SOLDE)
FROM COMPTES;

--
INSERT INTO COMPTES
VALUES ('13', 'Paul', '500');

commit;

savepoint preDeadlock2;

---- EXO 3 INTERBLOCAGE
UPDATE COMPTES SET Solde = Solde + 50 WHERE Nom='Pierre';

UPDATE COMPTES SET Solde = Solde + 200 WHERE Nom='Paul';

commit;

rollback ;