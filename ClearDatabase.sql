SELECT  'ALTER TABLE [' + TABLE_SCHEMA + '].[' + TABLE_NAME + '] NOCHECK CONSTRAINT all' AS [Disable constraints],
        'DELETE FROM [' + TABLE_SCHEMA + '].[' + table_name + ']' AS [Remove data],
        'ALTER TABLE [' + TABLE_SCHEMA + '].[' + TABLE_NAME + '] WITH CHECK CHECK CONSTRAINT all' AS [Enable constraints],
        'EXEC sp_executesql N''
            IF (SELECT OBJECTPROPERTY(OBJECT_ID(N''''[' + TABLE_SCHEMA + '].[' + TABLE_NAME + ']''''), ''''TableHasIdentity'''')) = 1
            BEGIN
                DBCC CHECKIDENT (''''[' + TABLE_SCHEMA + '].[' + TABLE_NAME + ']'''', RESEED, 0)
            END
        ''' AS [Reseed identity columns]
FROM INFORMATION_SCHEMA.TABLES
WHERE   TABLE_TYPE = 'BASE TABLE' AND
        TABLE_NAME <> 'sysdiagrams' 
ORDER BY TABLE_NAME DESC
