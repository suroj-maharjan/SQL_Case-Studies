BULK INSERT baby_names_db.names
FROM 'E:\SQL\Baby Name Trend Analysis\names_data.csv'
WITH (
    --FIRSTROW = 2,                    -- Skip header row
    FIELDTERMINATOR = ',',          -- Comma-separated values
    ROWTERMINATOR = '0x0a',           -- Line break   '\n'
    --CODEPAGE = '65001',             -- UTF-8 (use 'ACP' for ANSI)
    --KEEPNULLS,                      -- Keep NULLs if present
    TABLOCK                         -- For faster insert
);