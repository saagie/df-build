#!/bin/bash

# Backend
cp app/config/parameters.jenkins.yml app/config/parameters.yml
composer install
if [ -z "$SKIP_TESTS" ]; then
    if [ -z "$COVERAGE" ]; then
        if [ -n "$TEST_CLASS" ]; then
            echo "One test : $TEST_CLASS"
            php ./phpunit.phar -c app --log-junit junit-report.xml $TEST_CLASS
        else
            echo "All tests"
            php vendor/phing/phing/bin/phing
        fi
    else
        php vendor/phing/phing/bin/phing build-coverage
    fi
fi
# Frontend
if [ -z "$SKIP_FRONT" ]; then
    npm install --unsafe-perm
    bower --allow-root install
    gulp
    gulp test
    #Copie all assets at the end
    php app/console assets:install
fi
