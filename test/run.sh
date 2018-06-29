#!/bin/bash

./vim-syntax-legend -i sample/main.c -o sample/c.vsl
./vim-syntax-legend -i sample/main-changes.c -o sample/c-changes.vsl -p sample/c.vsl

diff -urN sample/c.vsl sample/c-changes.vsl
