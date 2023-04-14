-- * THREE QUERIES TO GET THE THIEF, THE DESTINATION CITY, THE ACCOMPLICE


-- Get Caller Name (Thief)
SELECT name AS Thief
FROM people
WHERE license_plate IN
     -- Get license plates of all suspects at bakery security logs
    (SELECT license_plate
     FROM bakery_security_logs
     WHERE YEAR = 2021
       AND MONTH = 07
       AND DAY = 28
       AND HOUR = 10
       AND MINUTE >= 15
       AND MINUTE <= 25
       -- Compare license plates
       INTERSECT
       -- Get license plates of all matching callers
       SELECT license_plate
       FROM people
       WHERE phone_number IN
          -- Get phone numbers of callers with the below conditions
         (SELECT caller
          FROM phone_calls
          WHERE YEAR = 2021
            AND MONTH = 07
            AND DAY = 28
            AND duration < 60
            -- Look for intersecting phone numbers
            INTERSECT
            -- Get phone numbers of matching suspects below
            SELECT phone_number
            FROM people
            JOIN bank_accounts ON people.id = bank_accounts.person_id
            WHERE account_number IN
               -- Get account numbers of suspects from Leggett Street
              (SELECT account_number
               FROM atm_transactions
               WHERE YEAR = 2021
                 AND MONTH = 07
                 AND DAY = 28
                 AND atm_location = "Leggett Street"
                 AND transaction_type = "withdraw"
                --  Compare both
                 INTERSECT
                 -- Get account numbers of people who took a flight
                 SELECT account_number
                 FROM bank_accounts
                 WHERE person_id IN
                   -- Get people id's
                   (SELECT id
                    FROM people
                    -- based on all passport numbers of people who were on those flights
                    WHERE passport_number IN
                        (SELECT passport_number
                         FROM passengers
                         WHERE flight_id IN
                             (SELECT id
                              FROM flights
                              WHERE id IN
                                  (SELECT flight_id
                                   FROM passengers
                                   WHERE passport_number =
                                        -- Get passport numbers of people who took a flight the day after
                                        -- with the specified conditions
                                       (SELECT passport_number
                                        FROM passengers
                                        WHERE flight_id IN
                                            (SELECT id
                                             FROM flights
                                             WHERE YEAR = 2021
                                               AND MONTH = 07
                                               AND DAY = 29
                                               AND HOUR < 12
                                               AND origin_airport_id =
                                                 (SELECT id
                                                  FROM airports
                                                  WHERE city = "Fiftyville"))
                                          -- Look for intersected passport numbers With the result below
                                          INTERSECT
                                          -- Get passport numbers based on id
                                          SELECT passport_number
                                          FROM people
                                          WHERE id IN
                                             -- Get their id's
                                            (SELECT person_id
                                             FROM bank_accounts
                                             WHERE account_number IN
                                                  -- Query all transactions at leggett Street
                                                 (SELECT account_number
                                                  FROM atm_transactions
                                                  WHERE YEAR = 2021
                                                    AND MONTH = 07
                                                    AND DAY = 28
                                                    AND atm_location = "Leggett Street"
                                                    AND transaction_type = "withdraw" ))))))))));


-- Destination City name
-- A Subquery of the Thief Query with 2 additional queries
SELECT city AS Destination_City
FROM airports
WHERE id =
        (SELECT destination_airport_id
         FROM flights
         WHERE id =
                (SELECT flight_id
                 FROM passengers
                 WHERE passport_number =
                (SELECT passport_number
                 FROM passengers
                 WHERE flight_id IN
                        (SELECT id
                         FROM flights
                         WHERE YEAR = 2021
                         AND MONTH = 07
                         AND DAY = 29
                         AND HOUR < 12
                         AND origin_airport_id =
                                (SELECT id
                                 FROM airports
                                 WHERE city = "Fiftyville"))
                         INTERSECT
                         SELECT passport_number
                         FROM people
                         WHERE id IN
                        (SELECT person_id
                         FROM bank_accounts
                         WHERE account_number IN
                                (SELECT account_number
                                 FROM atm_transactions
                                 WHERE YEAR = 2021
                                 AND MONTH = 07
                                 AND DAY = 28
                                 AND atm_location = "Leggett Street"
                                 AND transaction_type = "withdraw" )))));

                                 
-- Get Accomplice name
-- a Subquery of Thief Query with additional queries
SELECT name AS Accomplice
FROM people
WHERE phone_number =
        (SELECT receiver
        FROM phone_calls
        WHERE year = 2021
        AND month = 07
        AND day = 28
        AND duration < 60
        AND caller =
                (SELECT caller
                 FROM phone_calls
                 WHERE YEAR = 2021
                 AND MONTH = 07
                 AND DAY = 28
                 AND duration < 60
                 INTERSECT
                 SELECT phone_number
                 FROM people
                 JOIN bank_accounts ON people.id = bank_accounts.person_id
                 WHERE account_number IN
                        (SELECT account_number
                         FROM atm_transactions
                         WHERE YEAR = 2021
                                 AND MONTH = 07
                                 AND DAY = 28
                                 AND atm_location = "Leggett Street"
                                 AND transaction_type = "withdraw"
                                 INTERSECT
                                 SELECT account_number
                                 FROM bank_accounts
                                 WHERE person_id IN
                                (SELECT id
                                 FROM people
                                 WHERE passport_number IN
                                (SELECT passport_number
                                         FROM passengers
                                         WHERE flight_id IN
                                        (SELECT id
                                         FROM flights
                                         WHERE id IN
                                                (SELECT flight_id
                                                 FROM passengers
                                                 WHERE passport_number =
                                                (SELECT passport_number
                                                 FROM passengers
                                                 WHERE flight_id IN
                                                        (SELECT id
                                                         FROM flights
                                                         WHERE YEAR = 2021
                                                         AND MONTH = 07
                                                         AND DAY = 29
                                                         AND HOUR < 12
                                                         AND origin_airport_id =
                                                                (SELECT id
                                                                 FROM airports
                                                                 WHERE city = "Fiftyville"))
                                                         INTERSECT
                                                         SELECT passport_number
                                                         FROM people
                                                         WHERE id IN
                                                        (SELECT person_id
                                                         FROM bank_accounts
                                                         WHERE account_number IN
                                                                (SELECT account_number
                                                                 FROM atm_transactions
                                                                 WHERE YEAR = 2021
                                                                 AND MONTH = 07
                                                                 AND DAY = 28
                                                                 AND atm_location = "Leggett Street"
                                                                 AND transaction_type = "withdraw" ))))))))
                 INTERSECT
                 SELECT phone_number
                 FROM people
                 WHERE license_plate IN
                        (SELECT license_plate
                         FROM bakery_security_logs
                         WHERE year = 2021
                         AND month = 07
                         AND day = 28
                         AND hour = 10
                         AND minute >= 15
                         AND minute <= 25
                         AND activity = "exit")));