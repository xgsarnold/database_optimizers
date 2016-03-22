# Database Optimizations

## Description

Given an existing application which generates a report from a large data set, the assignment was to improve the efficiency of the report using database optimization methods. After implementing each improvement we needed to measure the time the app took to perform its searches.

First, improvements included adding indices to appropriate tables and columns. This drastically increased seed time, since the database has to construct a data tree beside inserting the seed into the database itself. Alternatively, implementing indices reduced load time to less than 1/200th of the time.

Second, since the load time was still quite long at just under 7 seconds, I refactored the controller variables and loops to match the new associations in the models. By associating tables to other tables through their immediate associations, I managed to reduce search time from approx. 6.5 seconds to approx. .02 seconds.

## Initial Measurements

* Seed time: 1465.676242 seconds
* Load page: 1500 seconds
* Memory used by Ruby: 650 MB

## Measurements with Indices

* Seed time with indices: 1958.015949 seconds
* Load page: 6.523915 seconds

## Measurements after Refactoring

* Load page: .021 seconds
* Memory used: 400 MB

## Example SQL Query for Search Bar

SELECT
FROM assemblies AS a
  INNER JOIN sequences AS s On a.id = s.assembly_id
  INNER JOIN genes AS g ON s.id = g.sequence_id
  INNER JOIN hits AS h ON g.id = h.subject_id AND h.subject_type = "Gene"
WHERE a.name LIKE "%@search%"
  OR g.dna LIKE "%@search%"
  OR h.match_gene_name LIKE "%@search%";
