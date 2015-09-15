[![Build Status](https://travis-ci.org/bartlomiejh/sobi.svg?branch=master)](https://travis-ci.org/bartlomiejh/sobi)
[![Coverage Status](https://coveralls.io/repos/bartlomiejh/sobi/badge.svg?branch=master&service=github)](https://coveralls.io/github/bartlomiejh/sobi?branch=master)
[![Dependency Status](https://gemnasium.com/bartlomiejh/sobi.svg)](https://gemnasium.com/bartlomiejh/sobi)

# sobi

Client-server communication through redis server.

Client sends package (which consists of two fields bike_id,
and message) to the redis queue. Server pools queue and saves received packages into the database.

## Requirements

- ruby 2.2.2
- running redis server

## Installation

Clone the repository then go to the project root dir and run:

    $ bundle install

Configure redis server settings in:

    `config/redis.yml`

**Server**

Server is a rails app so start it with:

   $ rails s

**Client**

Client is ruby script, and you can checkout it usage with:

    $ ruby bin/client -h

## Usage

**Server**

To get list of all packages go to the root of the application.

Every 5 seconds from the application start application will fetch all packages from the defined (in redis.yml) queue and store them in database.
Package index page will be automatically refreshed every 5 seconds from first visit.

**Client**

You can push package to defined (in redis.yml) queue using provided CLI. You can specify value for package bike_id but message field will be automatically generated (690 length string).
Script returns length of the list after the push operations.

Examples:
- send message with bike_id = 1 to the development queue run:
   $ ruby bin/client -h
- send message with bike_id = 2 to the production queue run:
   $ ruby bin/client -i 2 -e production

## Documentation

For now the only place for documentation is project spec directory