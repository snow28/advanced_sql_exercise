a. Find user by name (exact match)

SELECT s.*
FROM students as s
WHERE s.name = 'Dmytro'



b. Find user by surname (partial match)

SELECT s.*
FROM students as s
WHERE s.surname LIKE '%uda%'



c. Find user by phone number (partial match)

SELECT s.*
FROM students as s
WHERE s.phone_numbers LIKE '%612%'



d. Find user with marks by user surname (partial match)

SELECT s.id,s.name,s.surname,Count(*) as "Number_of_Results"
FROM students as s
	INNER JOIN "examResults" as ex
	ON s.id = ex.student_id
WHERE s.surname LIKE '%Revatoo%'
GROUP BY s.id
HAVING Count(*) > 0



5. Add trigger that will update column updated_datetime to current date in case of updating any of student. (0.3 point)

CREATE OR REPLACE FUNCTION update_changetimestamp_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = now();
   RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_ab_changetimestamp BEFORE UPDATE
    ON students FOR EACH ROW EXECUTE PROCEDURE
    update_changetimestamp_column();



6. Add validation on DB level that will check username on special characters (reject student name with next characters '@', '#', '$'). (0.3 point)

ALTER TABLE "students"
    ADD CONSTRAINT "name_value_check2" CHECK (name NOT LIKE '%@%' AND name NOT LIKE '%#%' AND name NOT LIKE '%$%')



7. Create snapshot that will contain next data: student name, student surname, subject name, mark (snapshot means that in case of changing some data in source table – your snapshot should not change). (0.3 point)

CREATE TABLE results_snapshot
AS SELECT s.name, s.surname, ex.mark, sub.name as Subject_Name
FROM "examResults" as ex
	INNER JOIN "students" as s
	ON ex.student_id = s.id
	INNER JOIN "subjects" as sub
	ON ex.subject_id = sub.id



8. Create function that will return average mark for input user. (0.3 point)

SELECT s.id, s.name, s.surname, AVG(ex.mark)
FROM "examResults" as ex
	INNER JOIN "students" as s
	ON ex.student_id = s.id
	INNER JOIN "subjects" as sub
	ON ex.subject_id = sub.id
WHERE s.id = 648
GROUP BY s.id, s.name, s.surname


9. Create function that will return avarage mark for input subject name. (0.3 point).

SELECT s.id, s.name, s.surname, AVG(ex.mark), sub.name as Subject_Name
FROM "examResults" as ex
	INNER JOIN "students" as s
	ON ex.student_id = s.id
	INNER JOIN "subjects" as sub
	ON ex.subject_id = sub.id
WHERE s.id = 648 AND sub.name = 'English'
GROUP BY s.id, s.name, s.surname, sub.name


10. Create function that will return student at "red zone" (red zone means at least 2 marks <=3). (0.3 point)

SELECT s.id, s.name, s.surname, AVG(ex.mark), sub.name as Subject_Name
FROM "examResults" as ex
	INNER JOIN "students" as s
	ON ex.student_id = s.id
	INNER JOIN "subjects" as sub
	ON ex.subject_id = sub.id
GROUP BY s.id, s.name, s.surname, sub.name
HAVING AVG(ex.mark) < 2 AND AVG(ex.mark) <> 0
