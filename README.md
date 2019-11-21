# Package UtilDate

Package plsql language for date control functions.

## Installation

Compile in your scheme.

## Unit test
Testing with utPlsql version 3.
Execute:
```
set serveroutput on
begin
  ut.run('hr:test.plsql.j.utildate');
end;
/
```
NOTE: replace "hr" for your scheme


## Additional documentation
Use PlDoc (http://pldoc.sourceforge.net/maven-site/) for source code documentation. (It placed in "pldoc").

Documentation execution:
```
#Windows
call pldoc.bat -doctitle 'plsql-j-utildate' -d pldoc -inputencoding ISO-8859-15 src/*.*

#Linux:
pldoc.sh -doctitle \"plsql-j-utildate\" -d pldoc -inputencoding ISO-8859-15 src/*.*
```
