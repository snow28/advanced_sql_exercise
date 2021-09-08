ALTER TABLE "students" {
    name varchar(255) NOT NULL CONSTRAINT name_value_check CHECK name NOT LIKE '%@%'
}

CREATE TABLE "students" (
  "id" SERIAL PRIMARY KEY,
  "name" varchar(255) NOT NULL,
  "surname" varchar(255) NOT NULL,
  "date_of_birth" date,
  "phone_numbers" varchar(255),
  "primary_skill" varchar(255),
  "created_at" timestamp NOT NULL,
  "updated_at" timestamp
);
CREATE TABLE "subjects" (
  "id" SERIAL PRIMARY KEY,
  "name" varchar(255) NOT NULL,
  "tutor" varchar(255),
  "value" int NOT NULL
);
CREATE TABLE "examResults" (
  "id" SERIAL PRIMARY KEY,
  "student_id" int NOT NULL,
  "subject_id" int NOT NULL,
  "mark" int
);

ALTER TABLE "examResults" ADD FOREIGN KEY ("subject_id") REFERENCES "subjects" ("id");
ALTER TABLE "examResults" ADD FOREIGN KEY ("student_id") REFERENCES "students" ("id");






