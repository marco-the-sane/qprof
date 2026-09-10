# qprof
bash shell script for post-mortem profiling of a Vertica query
```
Usage: qprof {-f query_file | -s statement_id -t transaction_id} [-o output_file] [-rp resource_pool] [-cc] [-gz]
 -f query_file (it should not contain the 'profile' keyword
 -s statement_id -t transaction_id is alternative to '-f file'
 -o output_file to set the output file (default sprof.out)
 -rp resource_pool to set the resource pool where the query in '-f file' is executed
 -gz to gzip the output file
 -cc to clear the cache
 -u user (overwrites VSQL_USER)
 -p passwd (overwrites VSQL_PASSWORD)
```
`qprof` can, in most cases, just be run by supplying a *.sql file containing the single query we want to profile:
```
$ qprof -f myquery.sql
```
`qprof` will read the query file, precede it with the `PROFILE` keyword, and run it, so that the query is run and all execution engine profile values are generated and stored in Vertica's `execution_engine_profiles` system monitoring table.

That command also issues a message containing the transaction id and the statement id of the query just submitted. `qprof` captures txn-id and stmt-id, and uses them, once the query is run, to query `execution_engine_profiles` and several other monitoring tables, to generate an extensive text output file (`qprof.out` by default) that can then be used to investigate in detail what actually happened during the query's execution.

Install it by copying the executable `qprof-0-5.sh` (or any later version in this repository) onto a Linux workstation with the Vertica client stack - especially with Vertica's `vsql` standard client. Or, if circumstances allow, directly on a Vertica node. Make sure you have an entry in your `$PATH` variable that points to the directory in which the executable resides.
Then, set the following environment variables:
```
export VSQL_HOST=sbx1
export VSQL_PORT=5433
export VSQL_DATABASE=sbx
export VSQL_USER=dbadmin
export VSQL_PASSWORD=pwd
```
To keep the invoking command stable across versions, create a symbolic link `qprof` in the same directory as `qprof-?.*.sh` pointing to the newest version.
.. and you should be set.

