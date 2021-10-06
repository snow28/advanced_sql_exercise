a. 100K of users

INSERT INTO students(name, surname, primary_skill, phone_numbers, created_at)
SELECT
   (
    CASE (RANDOM() * 5)::INT
        WHEN 0 THEN 'Andrey'
        WHEN 1 THEN 'Dmytro'
        WHEN 2 THEN 'Egor'
        WHEN 3 THEN 'Tomasz'
        WHEN 4 THEN 's.'
        WHEN 5 THEN 'Nick'
    END
  ) AS name,
  (
    CASE (RANDOM() * 4)::INT
        WHEN 0 THEN 'Revatoo'
        WHEN 1 THEN 'Menatto'
        WHEN 2 THEN 'Ponatto'
        WHEN 3 THEN 'Duda'
        WHEN 4 THEN ''
    END
  ) AS surname,
  (
      CASE (RANDOM() * 4)::INT
          WHEN 0 THEN 'Programming'
          WHEN 1 THEN 'Natural Nutrition'
          WHEN 2 THEN 'Astro Physics'
          WHEN 3 THEN 'History'
          WHEN 4 THEN 'History of Ancient Greece'
      END
    ) AS primary_skill,
  floor(random() * (999999-222222+1) + 222222)::INT as phone_numbers,
  CURRENT_TIMESTAMP as created_at
FROM GENERATE_SERIES(1, 100000) seq;

b. 1K of subjects

INSERT INTO subjects(name, tutor, value)
SELECT
  (
    CASE (RANDOM() * 5)::INT
      WHEN 0 THEN 'Math'
      WHEN 1 THEN 'History'
      WHEN 2 THEN 'Physics'
      WHEN 3 THEN 'English'
      WHEN 4 THEN 'Economic'
      WHEN 5 THEN 'Programing'
    END
  ) AS name,
  (
      CASE (RANDOM() * 5)::INT
        WHEN 0 THEN 'Pawel'
        WHEN 1 THEN 'Georg'
        WHEN 2 THEN 'Michal'
        WHEN 3 THEN 'Mark'
        WHEN 4 THEN 'Elon'
        WHEN 5 THEN 'Donald'
      END
    ) AS tutor,
    (
        CASE (RANDOM() * 5)::INT
          WHEN 0 THEN 0
          WHEN 1 THEN 1
          WHEN 2 THEN 2
          WHEN 3 THEN 3
          WHEN 4 THEN 4
          WHEN 5 THEN 5
        END
      ) AS value
FROM GENERATE_SERIES(1, 1000);

c. 1 million of marks
HELP LINK : https://stackoverflow.com/questions/19145761/postgres-for-loop

DO
$do$
BEGIN
   FOR i IN 1..1000000 LOOP
		INSERT INTO "examResults"(student_id, subject_id, mark, created_at)
		SELECT
			(SELECT * FROM (SELECT id FROM students ORDER BY RANDOM() LIMIT 1) AS X) as student_id,
			(SELECT * FROM (SELECT id FROM subjects ORDER BY RANDOM() LIMIT 1) AS Y) as subject_id,
			(
				CASE (RANDOM() * 5)::INT
				  WHEN 0 THEN 0
				  WHEN 1 THEN 1
				  WHEN 2 THEN 2
				  WHEN 3 THEN 3
				  WHEN 4 THEN 4
				  WHEN 5 THEN 5
				END
			) AS mark,
			now();
   END LOOP;
END
$do$;
