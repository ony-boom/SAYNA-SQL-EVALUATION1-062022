################ 9 ################
# Livres empruntes
SELECT *
FROM livres
WHERE livres.NL IN (SELECT emprunter.NL FROM emprunter);



################ 10 ################
# les livres empruntés par Jeannette Lecoeur
SELECT *
FROM livres
WHERE livres.NL IN (SELECT emprunter.NL
                    FROM emprunter
                    WHERE emprunter.NA = find_member('Lecoeur', 'Jeanette'));



################ 11 ################
# les livres empruntés en septembre 2021
SELECT livres.NO, livres.NL, livres.editeur, e.dateEmp
FROM livres
         JOIN emprunter e ON livres.NL = e.NL
WHERE e.dateEmp BETWEEN '2021-09-01' AND '2021-10-01';



################ 12 ################
# Tous les adhérents qui ont emprunté un livre de Fedor Dostoievski, avec multiple "select"
SELECT *
FROM adherents
WHERE adherents.NA IN (SELECT emprunter.NA
                       FROM emprunter
                       WHERE emprunter.NL =
                             (SELECT livres.NL
                              FROM livres
                              WHERE livres.NO = find_book_by_author('Fedor Dostoievski')));

# Tous les adhérents qui ont emprunté un livre de Fedor Dostoievski, avec "JOIN"
SELECT adherents.nom, adherents.prenom
FROM adherents
         JOIN emprunter e ON adherents.NA = e.NA
WHERE e.NL = (SELECT livres.NL
              FROM livres
              WHERE livres.NO = find_book_by_author('Fedor Dostoievski'));



################ 13 ################
# Mise a jour DB; Inscription d'Olivier
INSERT INTO adherents(nom, prenom, adresse, tel)
VALUES ('Dupond', 'Olivier', '76 quai de la Loire,
75019 Paris', '0102030405');



################ 14 ################
# 14 mises à jour de la BD.
SELECT @nl_1 := livres.NL
FROM livres
WHERE livres.NO = find_book_by_title('Au coeur des ténèbres');

SET @na_martine = find_member('CROZIER', 'Martine');
SET @date_emp = NOW();
SET @max_emp = 14;

SET @nl_2 = 23;

INSERT INTO emprunter(NL, dateEmp, dureeMax, dateRet, NA)
VALUES (@nl_1, @date_emp, @max_emp, NULL, @na_martine),
       (@nl_2, @date_emp, @max_emp, NULL, @na_martine);



################ 15 ################
# mise à jour de la BD. Retour des livres par cyril
SET @cyril_na = find_member('FREDERIC', 'Cyril');
UPDATE emprunter
SET dateRet = NOW()
WHERE emprunter.NA = @cyril_na;



################ 16 ################
# requête pour l'emprunt de cyril, livre NO 23
INSERT INTO emprunter
VALUES (23, NOW(), 14, NULL, @cyril_na);
# remarque => puisqu'un adherant a déja emprunter ce livre avant Mr Cyril le même date,
# il ne pourra pas l'emprunter, car une erreur comme étant "Duplication d'identifants "
# s'affichera et puis c'est logique car le livre n'est même pas là.


################ 17 ################
# requête pour l'emprunt de cyril, livre NO 29
INSERT INTO emprunter
VALUES (29, NOW(), 14, NULL, @cyril_na);
# remarque => puisque la table "emprunter" a deux clés primaires, cet emprunt peut se faire dans
# la base de donnée car  aucune duplication n'éxistera.
# (Les livres sont empruntés a des dates differentes)


################ 18 ################
# les auteurs du titre « Voyage au bout de la nuit »
SELECT oeuvres.auteur
FROM oeuvres
WHERE oeuvres.NO = find_book_by_title('Voyage au bout de la nuit');


################ 19 ################
SELECT livres.editeur
FROM livres
WHERE livres.NO = find_book_by_title('Narcisse et Goldmund');


################ 20 ################
SELECT adherents.nom, adherents.prenom, adherents.NA
FROM adherents
         JOIN emprunter e ON adherents.NA = e.NA
WHERE DATE_ADD(e.dateEmp, INTERVAL e.dureeMax DAY) > e.dateRet;



################ 21 ################
# les livres actuellement en retard
SELECT emprunter.NL
FROM emprunter
WHERE DATE_ADD(emprunter.dateEmp, INTERVAL emprunter.dureeMax DAY) > emprunter.dateRet;



################ 22 ################
# les adhérents en retard avec le nombre de livre en retard et la
# moyenne du nombre de jour de retard.
SELECT adherents.NA,
       adherents.prenom,
       COUNT(e.NL)                                AS 'nombre de livre en retard',
       ROUND(AVG(DATEDIFF(e.dateRet, e.dateEmp))) AS 'moyenne du nombre de jour de retard'
FROM adherents
         JOIN emprunter e ON adherents.NA = e.NA
WHERE DATE_ADD(e.dateEmp, INTERVAL e.dureeMax DAY) >= e.dateRet
  AND e.dateEmp < e.dateRet
GROUP BY adherents.NA;



################ 23 ################
# Nombre de livres empruntées par auteur.
SELECT DISTINCT oeuvres.auteur, COUNT(emprunter.NL) AS 'Nombre de livre emprunter'
FROM emprunter
         JOIN oeuvres
         JOIN livres l ON emprunter.NL = l.NL AND oeuvres.NO = l.NO
GROUP BY oeuvres.auteur;



################ 24 ################
# Nombre de livres empruntés par éditeur.
SELECT DISTINCT l.editeur, COUNT(emprunter.NL) AS 'Nombre de livre emprunter'
FROM emprunter
         JOIN livres l ON emprunter.NL = l.NL
GROUP BY l.editeur;



################ 25 ################
# Durée moyenne des emprunts rendus
SELECT AVG(DATEDIFF(emprunter.dateRet, emprunter.dateEmp)) AS 'Durée moyenne des emprunts rendus'
FROM emprunter
WHERE emprunter.dateRet IS NOT NULL
  AND emprunter.dateRet > emprunter.dateEmp
  AND DATE_ADD(emprunter.dateEmp, INTERVAL emprunter
    .dureeMax DAY) <= emprunter.dateRet;



################ 26 ################
# Durée moyenne des retards pour l’ensemble des emprunts.
SELECT AVG(DATEDIFF(emprunter.dateRet, DATE_ADD(emprunter.dateEmp, INTERVAL emprunter
    .dureeMax DAY))) AS 'Durée moyenne des retards pour l’ensemble des emprunts'
FROM emprunter
WHERE emprunter.dateRet > emprunter.dateEmp
  AND DATE_ADD(emprunter.dateEmp, INTERVAL emprunter
    .dureeMax DAY) <= emprunter.dateRet;


################ 26 ################
# En utilisant la reponse du question NO 22
SELECT AVG(`moyenne du nombre de jour de retard`) AS 'durée moyenne des retards parmi les seuls retardataires'
FROM adherant_retard;