[![Build Status](https://travis-ci.org/bartlomiejh/sobi.svg?branch=master)](https://travis-ci.org/bartlomiejh/sobi)
[![Coverage Status](https://coveralls.io/repos/bartlomiejh/sobi/badge.svg?branch=master&service=github)](https://coveralls.io/github/bartlomiejh/sobi?branch=master)
[![Dependency Status](https://gemnasium.com/bartlomiejh/sobi.svg)](https://gemnasium.com/bartlomiejh/sobi)

# sobi

Client-server communication through redis server.

## Installation

It requires ruby 2.2.2 and running redis server.

It's a rails app so after cloning go to project root and run:

    $ bundle install
    $ rails s

You can fill db with some sample data using:

    $ rake db:seed

You can change redis server settings in:
    `config/redis.yml`

## Usage

To get list of all packages go to the root of the application.

Every 5 seconds from the application start application will fetch all packages from the defined queue and store them in database.
Package index page will be automatically refreshed every 5 seconds from first visit.

## Documentation

For now the only place for documentation is project spec directory