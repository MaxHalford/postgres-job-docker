-- Adapted from https://github.com/alberanid/imdbpy/issues/130#issuecomment-365707620


-- The following for loop deletes all the existing foreign keys; there are no
-- foreign keys initially but this is useful if you wish to run the script a
-- second time.
DO
$do$
DECLARE r RECORD;
BEGIN
  FOR r in (SELECT table_name, constraint_name FROM information_schema.table_constraints WHERE table_schema = 'public' AND constraint_name LIKE '%fkey%') loop
    RAISE info '%','Dropping '|| r.constraint_name;
    EXECUTE CONCAT('ALTER TABLE "public".' || r.table_name || ' DROP CONSTRAINT ' || r.constraint_name);
  END LOOP;
END
$do$;


ALTER TABLE aka_name
ADD FOREIGN KEY (person_id) REFERENCES name(id);


DELETE FROM aka_title
WHERE movie_id IN (SELECT movie_id FROM aka_title EXCEPT SELECT id FROM title);

DELETE FROM aka_title
WHERE episode_of_id IN (SELECT episode_of_id FROM aka_title EXCEPT SELECT id FROM aka_title);

ALTER TABLE aka_title
ADD FOREIGN KEY (kind_id) REFERENCES kind_type(id),
ADD FOREIGN KEY (episode_of_id) REFERENCES aka_title(id),
ADD FOREIGN KEY (movie_id) REFERENCES title(id);


DELETE FROM cast_info
WHERE movie_id IN (SELECT movie_id FROM cast_info EXCEPT SELECT id FROM title);

ALTER TABLE cast_info
ADD FOREIGN KEY (person_id) REFERENCES name(id),
ADD FOREIGN KEY (movie_id) REFERENCES title(id),
ADD FOREIGN KEY (person_role_id) REFERENCES char_name(id),
ADD FOREIGN KEY (role_id) REFERENCES role_type(id);


DELETE FROM complete_cast
WHERE movie_id IN (SELECT movie_id FROM complete_cast EXCEPT SELECT id FROM title);

ALTER TABLE complete_cast
ADD FOREIGN KEY (movie_id) REFERENCES title(id),
ADD FOREIGN KEY (subject_id) REFERENCES comp_cast_type(id),
ADD FOREIGN KEY (status_id) REFERENCES comp_cast_type(id);


DELETE FROM movie_companies
WHERE movie_id IN (SELECT movie_id FROM movie_companies EXCEPT SELECT id FROM title);

ALTER TABLE movie_companies
ADD FOREIGN KEY (movie_id) REFERENCES title(id),
ADD FOREIGN KEY (company_id) REFERENCES company_name(id),
ADD FOREIGN KEY (company_type_id) REFERENCES company_type(id);


DELETE FROM movie_keyword
WHERE movie_id IN (SELECT movie_id FROM movie_keyword EXCEPT SELECT id FROM title);

ALTER TABLE movie_keyword
ADD FOREIGN KEY (movie_id) REFERENCES title(id),
ADD FOREIGN KEY (keyword_id) REFERENCES keyword(id);


DELETE FROM movie_info
WHERE movie_id IN (SELECT movie_id FROM movie_info EXCEPT SELECT id FROM title);

ALTER TABLE movie_info
ADD FOREIGN KEY (movie_id) REFERENCES title(id),
ADD FOREIGN KEY (info_type_id) REFERENCES info_type(id);


DELETE FROM movie_link
WHERE movie_id IN (SELECT movie_id FROM movie_link EXCEPT SELECT id FROM title)
OR linked_movie_id IN (SELECT linked_movie_id FROM movie_link EXCEPT SELECT id FROM title);

ALTER TABLE movie_link
ADD FOREIGN KEY (movie_id) REFERENCES title(id),
ADD FOREIGN KEY (link_type_id) REFERENCES link_type(id),
ADD FOREIGN KEY (linked_movie_id) REFERENCES title(id);


ALTER TABLE person_info
ADD FOREIGN KEY (person_id) REFERENCES name(id),
ADD FOREIGN KEY (info_type_id) REFERENCES info_type(id);
