-- DDL
-- for now, we only set critical foreign key constraints

CREATE TABLE relationship (
    relationship_id VARCHAR(20) PRIMARY KEY,
    relationship_name VARCHAR(255) NOT NULL,
    is_hierarchical VARCHAR(1) NOT NULL,
    defines_ancestry VARCHAR(1) NOT NULL,
    reverse_relationship_id VARCHAR(20) NOT NULL,
    relationship_concept_id INTEGER NOT NULL
);

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
    FOREIGN KEY (concept_id_1) REFERENCES concept(concept_id),
    FOREIGN KEY (concept_id_2) REFERENCES concept(concept_id)
);

CREATE TABLE drug_strength (
    drug_concept_id INTEGER NOT NULL,
    ingredient_concept_id INTEGER NOT NULL,
    amount_value DOUBLE,
    amount_unit_concept_id INTEGER,
    numerator_value DOUBLE,
    numerator_unit_concept_id INTEGER,
    denominator_value DOUBLE,
    denominator_unit_concept_id INTEGER,
    box_size INTEGER,
    valid_start_date DATE NOT NULL,
    valid_end_date DATE NOT NULL,
    invalid_reason VARCHAR(1)
);

CREATE TABLE vocabulary (
    vocabulary_id VARCHAR(20) PRIMARY KEY,
    vocabulary_name VARCHAR(255) NOT NULL,
    vocabulary_reference VARCHAR(255),
    vocabulary_version VARCHAR(255),
    vocabulary_concept_id INTEGER NOT NULL
);

CREATE TABLE domain (
    domain_id VARCHAR(20) PRIMARY KEY,
    domain_name VARCHAR(255) NOT NULL,
    domain_concept_id INTEGER NOT NULL
);

CREATE TABLE concept_class (
    concept_class_id VARCHAR(20) PRIMARY KEY,
    concept_class_name VARCHAR(255) NOT NULL,
    concept_class_concept_id INTEGER NOT NULL
);

CREATE TABLE concept_synonym (
    concept_id INTEGER NOT NULL,
    concept_synonym_name VARCHAR(1000) NOT NULL,
    language_concept_id INTEGER NOT NULL
);

CREATE TABLE concept_ancestor (
    ancestor_concept_id INTEGER NOT NULL,
    descendant_concept_id INTEGER NOT NULL,
    min_levels_of_separation INTEGER NOT NULL,
    max_levels_of_separation INTEGER NOT NULL
);

-- Load data from CSV files
COPY concept FROM 'vocab/CONCEPT.csv' (AUTO_DETECT TRUE, DATE_FORMAT '%Y%m%d', QUOTE '');
COPY vocabulary FROM 'vocab/VOCABULARY.csv' (AUTO_DETECT TRUE, DATE_FORMAT '%Y%m%d', QUOTE '');
COPY domain FROM 'vocab/DOMAIN.csv' (AUTO_DETECT TRUE, DATE_FORMAT '%Y%m%d', QUOTE '');
COPY concept_class FROM 'vocab/CONCEPT_CLASS.csv' (AUTO_DETECT TRUE, DATE_FORMAT '%Y%m%d', QUOTE '');
COPY concept_relationship FROM 'vocab/CONCEPT_RELATIONSHIP.csv' (AUTO_DETECT TRUE, DATE_FORMAT '%Y%m%d', QUOTE '');
COPY relationship FROM 'vocab/RELATIONSHIP.csv' (AUTO_DETECT TRUE, DATE_FORMAT '%Y%m%d', QUOTE '');
COPY concept_synonym FROM 'vocab/CONCEPT_SYNONYM.csv' (AUTO_DETECT TRUE, DATE_FORMAT '%Y%m%d', QUOTE '');
COPY concept_ancestor FROM 'vocab/CONCEPT_ANCESTOR.csv' (AUTO_DETECT TRUE, DATE_FORMAT '%Y%m%d', QUOTE '');
COPY drug_strength FROM 'vocab/DRUG_STRENGTH.csv' (AUTO_DETECT TRUE, DATE_FORMAT '%Y%m%d', QUOTE '');