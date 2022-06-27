USE biblio;
-- by author
CREATE FUNCTION find_book_by_author(name varchar(100))
    RETURNS int DETERMINISTIC
    RETURN (SELECT NO
            FROM oeuvres
            WHERE LOWER(oeuvres.auteur) LIKE LOWER(name));

DROP FUNCTION find_book_by_author;

# by title
USE biblio;
CREATE FUNCTION find_book_by_title(title varchar(100))
    RETURNS int DETERMINISTIC
    RETURN (SELECT NO
            FROM oeuvres
            WHERE LOWER(oeuvres.titre) LIKE LOWER(title));

DROP FUNCTION find_book_by_title;