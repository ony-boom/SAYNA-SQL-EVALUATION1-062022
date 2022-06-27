USE biblio;
CREATE FUNCTION find_member(first_name varchar(30), last_name varchar(30))
    RETURNS int DETERMINISTIC
    RETURN (SELECT DISTINCT NA
            FROM adherents
            WHERE LOWER(adherents.nom) LIKE LOWER(first_name)
              AND LOWER(adherents.prenom) LIKE LOWER(last_name));

DROP FUNCTION find_member;