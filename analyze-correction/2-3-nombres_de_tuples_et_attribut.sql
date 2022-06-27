# Nombres de tuples
SELECT SUM(TABLE_ROWS) AS rows_count
FROM information_schema.tables
WHERE table_schema = 'biblio';

# Nombres de d'attributs
SELECT COUNT(*) AS attributs
FROM information_schema.columns
WHERE table_schema = 'biblio';

# SELECT COUNT(COLUMN_NAME)
# FROM INFORMATION_SCHEMA.COLUMNS
# WHERE TABLE_SCHEMA = 'biblio'
# AND COLUMN_KEY = 'PRI';