




CREATE TABLE BDA.ACTIVITY_LOGS (
  id NUMBER PRIMARY KEY,
  ATHLETE_ID NUMBER,
  activity_id NUMBER,
  action VARCHAR2(50),
  log_date DATE
);


CREATE SEQUENCE BDA.ACTIVITY_LOGS_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE;


CREATE OR REPLACE TRIGGER BDA.LOG_ACTIVITY_INSERTION
AFTER INSERT ON BDA.ACTIVITIES
FOR EACH ROW
BEGIN
  INSERT INTO BDA.ACTIVITY_LOGS (id,ATHLETE_ID, activity_id, action, log_date)
  VALUES (BDA.ACTIVITY_LOGS_SEQ.NEXTVAL,:NEW.ATHLETE_ID, :NEW.id, 'INSERT', SYSDATE);
  
  -- Call the preprocessing procedure
    preprocessing_data;
END;


INSERT INTO BDA.ACTIVITIES (ID, ATHLETE_ID, NAME, DISTANCE, MOVING_TIME, ELAPSED_TIME, TOTAL_ELEVATION_GAIN, SPORT_TYPE, START_DATE, START_DATE_LOCAL) 
VALUES (10, 43957994, 'Morning Run', 10.5, 3600, 3700, 150, 'Running', SYSTIMESTAMP, SYSTIMESTAMP);
COMMIT;


select * from BDA.ACTIVITY_LOGS;






