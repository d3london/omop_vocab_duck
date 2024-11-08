<p><a target="_blank" href="https://app.eraser.io/workspace/53RZfIGlWhCVn1ULHqpD" id="edit-in-eraser-github-link"><img alt="Edit in Eraser" src="https://firebasestorage.googleapis.com/v0/b/second-petal-295822.appspot.com/o/images%2Fgithub%2FOpen%20in%20Eraser.svg?alt=media&amp;token=968381c8-a7e7-472a-8ed6-4a6626da5501"></a></p>

# OMOP vocab table and mappings
## Summary
This repo contain scripts that perform two functions:

(1) Upload OMOP Athena vocabulary tables (currently for CDM 5.4) to a Motherduck database corresponding to given version, e.g:`md:omop_vocab_20240830` ;

(2) Check integrity of new source concept definitions, and source concept to omop standard concept mappings, using the Motherduck OMOP database, and export these as parquet files.

These steps are necessary to ensure that new concepts and mappings are compatible with vanilla OMOP vocabularies, and ensure that there are no conflicts between mappings that may be performed in different sessions or across different sites.

![omop_mapping](/.eraser/53RZfIGlWhCVn1ULHqpD___Ye9wifjPOhT3yQd8rlWom1YCXIp2___---figure---AVBfTVxVwmuT30gfcLbmR---figure---XF-P2gJMJCg9wGWJDKZTsQ.png "omop_mapping")

Exported parquet files can be used to perform source to OMOP concept mappings in health data pipelines. In the future, the intention is: (1) to version concept and concept_relationship files in S3, and (2) to build a live, immutable, cloud database that can be called by a mapper tool, and data pipelines across multiple sites.  

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