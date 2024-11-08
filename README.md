# OMOP vocab table and mappings
## Summary
This repo contains scripts that perform two functions:

(1) Use ```create_omop_vocab.sql``` to upload OMOP Athena vocabulary tables (currently for CDM 5.4) to a Motherduck database corresponding to given version, e.g:`md:omop_vocab_20240830` ;

(2) Use ```update_mappings.sql``` to check integrity of new source concept definitions, and source concept to OMOP standard concept mappings, using the Motherduck database, and export these as parquet files.

These steps are necessary to ensure that new concepts and mappings are compatible with vanilla OMOP vocabularies, and ensure that there are no conflicts between mappings that may be performed in different sessions or across different sites.

![omop_mapping](/.eraser/53RZfIGlWhCVn1ULHqpD___Ye9wifjPOhT3yQd8rlWom1YCXIp2___---figure---AVBfTVxVwmuT30gfcLbmR---figure---XF-P2gJMJCg9wGWJDKZTsQ.png "omop_mapping")

Exported parquet files can be used to perform source to OMOP concept mappings in health data pipelines. The roadmap for future development is: (1) to version concept and concept_relationship files in S3, and (2) to build a live, immutable, cloud database that can connect to both mapping tools and data pipelines across different sites.  

## Upload OMOP vocabulary
Only required once for each new vocabulary. Ensure that the vocabularies of choice are downloaded from [﻿athena.ohdsi.org/ ](https://athena.ohdsi.org/)and unzipped into `/vocab`. Note that these files are too large to keep in GitHub. We keep backups of active vocab versions in an AWS S3 bucket.

```
# ensure duckdb CLI is installed
brew install duckdb

# connect to motherduck database and execute script
duckdb md:omop_vocab_20240830
.read create_omop_vocab.sql
```
## Update mapping files
Definitions of new source concepts, and the relationships between source concepts and OMOP concepts, should be placed in `﻿mappings/concept` and `﻿mappings/concept_relationship` respectively as CSV files. These are uploaded to GitHub.

To update the parquet files that are used in data pipelines. run:

```
duckdb
.read update_mappings.sql
```
Parquet files for relevant `﻿concept` and `﻿concept_relationship`will be found in `﻿/export` .



<!--- Eraser file: https://app.eraser.io/workspace/53RZfIGlWhCVn1ULHqpD --->
