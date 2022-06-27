USE biblio;

# view pour la question no 27
CREATE VIEW adherant_retard AS
SELECT adherents.NA,
       adherents.prenom,
       COUNT(e.NL)                                AS 'nombre de livre en retard',
       ROUND(AVG(DATEDIFF(e.dateRet, e.dateEmp))) AS 'moyenne du nombre de jour de retard'
FROM adherents
         JOIN emprunter e ON adherents.NA = e.NA
WHERE DATE_ADD(e.dateEmp, INTERVAL e.dureeMax DAY) >= e.dateRet
  AND e.dateEmp < e.dateRet
GROUP BY adherents.NA;