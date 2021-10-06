--a. Find user by name (exact match)

SELECT s.*
FROM students as s
WHERE s.name = 'Dmytro'



--b. Find user by surname (partial match)

SELECT s.*
FROM students as s
WHERE s.surname LIKE '%uda%'



--c. Find user by phone number (partial match)

SELECT s.*
FROM students as s
WHERE s.phone_numbers LIKE '%612%'



--d. Find user with marks by user surname (partial match)

SELECT s.id,s.name,s.surname,Count(*) as "Number_of_Results"
FROM students as s
	INNER JOIN "examResults" as ex
	ON s.id = ex.student_id
WHERE s.surname LIKE '%Revatoo%'
GROUP BY s.id
HAVING Count(*) > 0



--5. Add trigger that will update column updated_datetime to current date in case of updating any of student. (0.3 point)

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

CREATE OR REPLACE FUNCTION update_changetimestamp_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = now();
   RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_ab_changetimestamp BEFORE UPDATE
    ON examResults FOR EACH ROW EXECUTE PROCEDURE
    update_changetimestamp_column();



--6. Add validation on DB level that will check username on special characters (reject student name with next characters '@', '#', '$'). (0.3 point)

ALTER TABLE "students"
    ADD CONSTRAINT "name_value_check2" CHECK (name NOT LIKE '%@%' AND name NOT LIKE '%#%' AND name NOT LIKE '%$%')



--7. Create snapshot that will contain next data: student name, student surname, subject name, mark (snapshot means that in case of changing some data in source table – your snapshot should not change). (0.3 point)

CREATE TABLE results_snapshot
AS SELECT s.name, s.surname, ex.mark, sub.name as Subject_Name
FROM "examResults" as ex
	INNER JOIN "students" as s
	ON ex.student_id = s.id
	INNER JOIN "subjects" as sub
	ON ex.subject_id = sub.id



--8. Create function that will return average mark for input user. (0.3 point)

SELECT s.id, s.name, s.surname, AVG(ex.mark)
FROM "examResults" as ex
	INNER JOIN "students" as s
	ON ex.student_id = s.id
	INNER JOIN "subjects" as sub
	ON ex.subject_id = sub.id
WHERE s.id = 648
GROUP BY s.id, s.name, s.surname


--9. Create function that will return average mark for input subject name. (0.3 point).

SELECT s.id, s.name, s.surname, AVG(ex.mark), sub.name as Subject_Name
FROM "examResults" as ex
	INNER JOIN "students" as s
	ON ex.student_id = s.id
	INNER JOIN "subjects" as sub
	ON ex.subject_id = sub.id
WHERE s.id = 648 AND sub.name = 'English'
GROUP BY s.id, s.name, s.surname, sub.name


--10. Create function that will return student at "red zone" (red zone means at least 2 marks <=3). (0.3 point)

SELECT s.id, s.name, s.surname, AVG(ex.mark), sub.name as Subject_Name
FROM "examResults" as ex
	INNER JOIN "students" as s
	ON ex.student_id = s.id
GROUP BY s.id, s.name, s.surname
HAVING AVG(ex.mark) < 2 AND AVG(ex.mark) <> 0

-- 12. Extra point 2 (1 point). Implement immutable data trigger. Create new table student_address. Add several rows
-- with test data and do not give access to update any information inside it. Hint: you can create trigger that will
-- reject any update operation for target table, but save new row with updated (merged with original) data into separate table.

-- Here I created in same way as in first and second file table called 'students2' and implemented trigger that
-- throw error when we try to update or insert smth to table.


create function do_not_change()
  returns trigger
as
$$
begin
  raise exception 'Cannot modify table procedure.
Contact the system administrator if you want to make this change.';
end;
$$
language plpgsql;

create trigger no_change_trigger
  before insert or update or delete on "students2"
  execute procedure do_not_change();




