#!/bin/bash -e
# Builds and tests SOCI backend ODBC at travis-ci.org
#
# Copyright (c) 2013 Mateusz Loskot <mateusz@loskot.net>
#
source ${TRAVIS_BUILD_DIR}/scripts/travis/common.sh

ODBC_TEST=${PWD}/../tests/odbc
if test ! -d ${ODBC_TEST}; then
    echo "ERROR: '${ODBC_TEST}' directory not found"
    exit 1
fi

cmake \
    -DCMAKE_BUILD_TYPE=Debug \
    -DSOCI_ASAN=ON \
    -DCMAKE_VERBOSE_MAKEFILE=ON \
    -DBUILD_TESTING=ON \
    -DSOCI_WITH_EMPTY=OFF \
    -DSOCI_WITH_ODBC=ON \
   ..

run_make

# Exclude the tests which can't be run due to the absence of ODBC drivers (MS
# SQL and MySQL).
LSAN_OPTIONS=suppressions=${TRAVIS_BUILD_DIR}/scripts/suppress_odbc.txt run_test -E 'soci_odbc_test_m.sql'
