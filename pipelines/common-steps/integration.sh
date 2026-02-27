#!/bin/bash

source todo-list-aws/bin/activate
set -x
export BASE_URL=$1

if[["$ENVIRONMENT" == "production"]]; then
    echo "Production tests"
    pytest -s test/integration/todoApiTest.py -m readonly --junitxml=result-integration.xml
else
    echo "Integration tests"
    pytest -s test/integration/todoApiTest.py --junitxml=result-integration.xml
fi