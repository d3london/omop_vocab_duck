-- Pull concept and concept_relationship from motherduck
ATTACH 'md:omop_vocab_20240830';

CREATE TABLE concept (
    concept_id INTEGER PRIMARY KEY,
    concept_name VARCHAR(255) NOT NULL,
    domain_id VARCHAR(20) NOT NULL,
    vocabulary_id VARCHAR(20) NOT NULL,
    concept_class_id VARCHAR(20) NOT NULL,
    standard_concept VARCHAR(1),
    concept_code VARCHAR(50) NOT NULL,
    valid_start_date DATE NOT NULL,
    valid_end_date DATE NOT NULL,
    invalid_reason VARCHAR(1)
);

CREATE TABLE concept_relationship (
    concept_id_1 INTEGER NOT NULL,
    concept_id_2 INTEGER NOT NULL,
    relationship_id VARCHAR(20) NOT NULL,
    valid_start_date DATE NOT NULL,
    valid_end_date DATE NOT NULL,
    invalid_reason VARCHAR(1),
    PRIMARY KEY (concept_id_1, concept_id_2, relationship_id),
    FOREIGN KEY (concept_id_1) REFERENCES concept(concept_id),
    FOREIGN KEY (concept_id_2) REFERENCES concept(concept_id)
);

INSERT INTO concept SELECT * FROM omop_vocab_20240830.concept;
INSERT INTO concept_relationship SELECT * FROM omop_vocab_20240830.concept_relationship;

-- Load new concept / concept_relationship
CREATE TEMP TABLE new_concepts AS 
SELECT * FROM read_csv_auto('mappings/concept/*.csv', 
                          dateformat='%Y%m%d');

CREATE TEMP TABLE new_relationships AS 
SELECT * FROM read_csv_auto('mappings/concept_relationship/*.csv', 
                           dateformat='%Y%m%d');

-- insert new mappings
INSERT INTO concept 
SELECT * FROM new_concepts 
WHERE concept_id NOT IN (SELECT concept_id FROM concept);

INSERT INTO concept_relationship 
SELECT * FROM new_relationships nr
WHERE NOT EXISTS (
    SELECT 1 
    FROM concept_relationship cr
    WHERE cr.concept_id_1 = nr.concept_id_1
    AND cr.concept_id_2 = nr.concept_id_2
    AND cr.relationship_id = nr.relationship_id
);

-- export concepts and relationships included in mappings
COPY (
    WITH export_concepts AS (
        SELECT DISTINCT concept_id_1 as concept_id 
        FROM new_relationships
        UNION
        SELECT DISTINCT concept_id_2 as concept_id 
        FROM new_relationships
    )
    SELECT c.* 
    FROM concept c
    JOIN export_concepts e ON c.concept_id = e.concept_id
) TO 'export/concept.parquet';

COPY (
    SELECT * FROM new_relationships
) TO 'export/concept_relationship.parquet';

DETACH omop_vocab_20240830;