DECLARE @Sql NVARCHAR(MAX);

DECLARE Cur CURSOR LOCAL FAST_FORWARD FOR
    SELECT 'ALTER INDEX ' + I.name + ' ON ' + S.name + '.' + T.name + ' REBUILD' as 'Statement'
    FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS DDIPS
    INNER JOIN sys.tables T on T.object_id = DDIPS.object_id
    INNER JOIN sys.schemas S on T.schema_id = S.schema_id
    INNER JOIN sys.indexes I ON I.object_id = DDIPS.object_id
    AND DDIPS.index_id = I.index_id
    WHERE DDIPS.database_id = DB_ID()
    AND avg_fragmentation_in_percent > 30
    and I.name is not null

OPEN Cur

  FETCH NEXT FROM Cur INTO @Sql

WHILE (@@FETCH_STATUS = 0)
BEGIN
     Exec sp_executesql @Sql
     FETCH NEXT FROM Cur INTO @Sql
END

CLOSE Cur
DEALLOCATE Cur;
