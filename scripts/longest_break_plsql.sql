CREATE OR REPLACE FUNCTION longest_break(
    p_start_date IN VARCHAR2,
    p_end_date IN VARCHAR2
) RETURN SYS_REFCURSOR AS
    prev_date TIMESTAMP (6) WITH TIME ZONE;
    curr_date TIMESTAMP (6) WITH TIME ZONE;
    max_break_length INTEGER := 0;
    current_break_length INTEGER := 0;
    start_date TIMESTAMP (6) WITH TIME ZONE;
    end_date TIMESTAMP (6) WITH TIME ZONE;
    break_length INTEGER;
    longest_break_cur SYS_REFCURSOR;
    ts_start_date TIMESTAMP (6) WITH TIME ZONE;
    ts_end_date TIMESTAMP (6) WITH TIME ZONE;
BEGIN
    -- Convert input dates to TIMESTAMP WITH TIME ZONE
    ts_start_date := TO_TIMESTAMP_TZ(p_start_date || ' 00:00:00.000000 +00:00', 'YYYY-MM-DD HH24:MI:SS.FF6 TZR');
    ts_end_date := TO_TIMESTAMP_TZ(p_end_date || ' 23:59:59.999999 +00:00', 'YYYY-MM-DD HH24:MI:SS.FF6 TZR');

    -- Initialize variables
    prev_date := NULL;

    -- Iterate through the rows ordered by start_date_local
    FOR activity_rec IN (
        SELECT TRUNC(TO_TIMESTAMP_TZ(START_DATE_LOCAL, 'DD-MON-YY HH.MI.SS.FF9 AM TZR')) AS activity_date
        FROM ACTIVITIES
        WHERE TRUNC(TO_TIMESTAMP_TZ(START_DATE_LOCAL, 'DD-MON-YY HH.MI.SS.FF9 AM TZR')) BETWEEN TRUNC(ts_start_date) AND TRUNC(ts_end_date)
        ORDER BY TRUNC(TO_TIMESTAMP_TZ(START_DATE_LOCAL, 'DD-MON-YY HH.MI.SS.FF9 AM TZR'))
    ) LOOP
        curr_date := activity_rec.activity_date;

        -- Check if this is the first date or if there's a break between the current and previous dates
        IF prev_date IS NOT NULL AND curr_date > prev_date + INTERVAL '1' DAY THEN
            -- Update the break length and check if it's longer than the max break
            current_break_length := EXTRACT(DAY FROM (curr_date - prev_date - INTERVAL '1' DAY));
            IF current_break_length > max_break_length THEN
                max_break_length := current_break_length;
                start_date := prev_date + INTERVAL '1' DAY; -- Start date of the break
                end_date := curr_date - INTERVAL '1' DAY; -- End date of the break
                break_length := max_break_length;
            END IF;
        END IF;

        -- Update previous date
        prev_date := curr_date;
    END LOOP;

    -- Open a cursor and return the longest break details
    OPEN longest_break_cur FOR
        SELECT start_date, end_date, break_length
        FROM DUAL;

    RETURN longest_break_cur;
END;

SET SERVEROUTPUT ON;

DECLARE
    longest_break_cur SYS_REFCURSOR;
    start_date TIMESTAMP (6) WITH TIME ZONE;
    end_date TIMESTAMP (6) WITH TIME ZONE;
    break_length INTEGER;
    p_start_date VARCHAR2(10) := '2023-01-01';
    p_end_date VARCHAR2(10) := '2023-12-31';
BEGIN
    -- Call the function and retrieve the cursor
    longest_break_cur := longest_break(p_start_date, p_end_date);

    -- Fetch the results from the cursor into variables
    FETCH longest_break_cur INTO start_date, end_date, break_length;

    -- Close the cursor
    CLOSE longest_break_cur;

    -- Output the results
    DBMS_OUTPUT.PUT_LINE('Longest Break:');
    DBMS_OUTPUT.PUT_LINE('Start Date: ' || TO_CHAR(start_date, 'DD-MON-YY'));
    DBMS_OUTPUT.PUT_LINE('End Date: ' || TO_CHAR(end_date, 'DD-MON-YY'));
    DBMS_OUTPUT.PUT_LINE('Break Length: ' || break_length);
END;

