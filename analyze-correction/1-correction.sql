DROP DATABASE IF EXISTS biblio;
CREATE DATABASE biblio;

USE biblio;

# Creation de la table oeuvres, car la table livres en depend
CREATE TABLE oeuvres
(
    NO     integer PRIMARY KEY AUTO_INCREMENT,
    titre  varchar(150) NOT NULL,
    auteur varchar(100),
    annee  integer,
    genre  varchar(30)
);

CREATE TABLE livres
(
    NL      integer PRIMARY KEY AUTO_INCREMENT,
    editeur varchar(50),
    NO      integer NOT NULL,
    FOREIGN KEY (NO) REFERENCES oeuvres (NO)
);

CREATE TABLE adherents
(
    NA     INT PRIMARY KEY AUTO_INCREMENT,
    nom    VARCHAR(30)  NOT NULL,
    prenom VARCHAR(30),
    adr    VARCHAR(100) NOT NULL,
    tel    CHAR(10)
);
# pour ne pas confondre adr a adherents
ALTER TABLE adherents RENAME COLUMN adr TO adresse;

CREATE TABLE emprunter
(
    NL       integer NOT NULL,
    FOREIGN KEY (NL) REFERENCES livres (NL),
    dateEmp  date    NOT NULL,
    dureeMax integer NOT NULL,
    dateRet  date,
    NA       integer NOT NULL,
    FOREIGN KEY (NA) REFERENCES adherents (NA),
    PRIMARY KEY (NL, dateEmp),
    INDEX (dateEmp)
);

