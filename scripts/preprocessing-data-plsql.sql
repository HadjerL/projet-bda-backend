CREATE OR REPLACE PROCEDURE preprocessing_data AS
BEGIN
    -- Remove rows with null values in SPLITS table
    DELETE FROM BDA.SPLITS WHERE 
        ACTIVITY_ID IS NULL OR 
        DISTANCE IS NULL OR 
        ELAPSED_TIME IS NULL ;

    -- Remove rows with null values in LAPS table
    DELETE FROM BDA.LAPS WHERE 
        ACTIVITY_ID IS NULL OR 
        DISTANCE IS NULL OR 
        ELAPSED_TIME IS NULL OR 
        START_DATE IS NULL OR 
        START_DATE_LOCAL IS NULL;

    -- Remove rows with null values in BESTEFFORTS table
    DELETE FROM BDA.BESTEFFORTS WHERE 
        ACTIVITY_ID IS NULL OR 
        ELAPSED_TIME IS NULL OR 
        START_DATE IS NULL OR 
        START_DATE_LOCAL IS NULL;

    -- Remove rows with null values in ACTIVITIES table
    DELETE FROM BDA.ACTIVITIES WHERE 
        ATHLETE_ID IS NULL OR 
        NAME IS NULL OR 
        DISTANCE IS NULL OR 
        MOVING_TIME IS NULL OR 
        START_DATE IS NULL OR 
        START_DATE_LOCAL IS NULL;

    -- Remove redundant or unnecessary data
    DELETE FROM BDA.SPLITS WHERE ACTIVITY_ID NOT IN (SELECT ID FROM BDA.ACTIVITIES);
    DELETE FROM BDA.LAPS WHERE ACTIVITY_ID NOT IN (SELECT ID FROM BDA.ACTIVITIES);
    DELETE FROM BDA.BESTEFFORTS WHERE ACTIVITY_ID NOT IN (SELECT ID FROM BDA.ACTIVITIES);

    -- Remove activities without associated athletes
    DELETE FROM BDA.ACTIVITIES WHERE ATHLETE_ID NOT IN (SELECT ID FROM BDA.ATHLETES);

    -- Verify foreign key constraints
    DELETE FROM BDA.BESTEFFORTS WHERE ATHLETE_ID NOT IN (SELECT ID FROM BDA.ATHLETES);
    DELETE FROM BDA.LAPS WHERE ATHLETE_ID NOT IN (SELECT ID FROM BDA.ATHLETES);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Preprocessing completed successfully.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('An error occurred during preprocessing: ' || SQLERRM);
END;
