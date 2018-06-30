# vim-syntax-legend

A script to save the result of a Vim syntax highlighting test sample as diff-able text file.

The purpose of the script is to address the testability of changes to the syntax definition files. Using a language sample to highlight, a Vim plugin writer can precisely see the effects of changes to the syntax highlight definitions. The alternative is to 'eyeball' the syntax highlighting output after changes.

### Example input and output

Cosider this C program input:

```c
int main(int argc, char *argv[])
{
    printf("Hello World\n");

    return 0;
}
```

We get the following output:

```
Legend:
--------

" - <default>                      " 4
% - cBlock                         " 10
$ - cBracket                       " 2
) - cNumber                        " 1
# - cParen                         " 14
' - cSpecial                       " 2
( - cStatement                     " 6
& - cString                        " 12
! - cType                          " 10

Source:
--------
int main(int argc, char *argv[])
!!! """"#!!! ##### !!!! #####$$#
{
%
    printf("Hello World\n");
    %%%%%%#&&&&&& &&&&&''&#%

    return 0;
    (((((( )%
}
%
```

### Features

 * Support to up to 95 syntax elements.
 * It is highly recommended to pass a previous input file so that the syntax element markers will remain stable. This is done using `-p` switch.


## Quick-start

If all is okay, the test script should present a diff over the output of the script, to so that the legend for the syntax highlight is stable between executions.

The test script:

```
./test/run.sh
```

Should output somthing similar to the following:

```diff
--- sample/c.vsl        2018-06-29 19:39:13.334324075 +0300
+++ sample/c-changes.vsl        2018-06-29 19:39:13.371323446 +0300
@@ -6,9 +6,7 @@
 $ - cBracket
 ) - cNumber
 # - cParen
-' - cSpecial
 ( - cStatement
-& - cString
 ! - cType

 Source:
@@ -17,9 +15,6 @@
 !!! """"#!!! ##### !!!! #####$$#
 {
 %
-    printf("Hello World\n");
-    %%%%%%#&&&&&& &&&&&''&#%
-
     return 0;
     (((((( )%
 }
```

