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

    config/redis.yml

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

   `$ ruby bin/client`

- send message with bike_id = 2 to the production queue run:

   `$ ruby bin/client -i 2 -e production`

## Documentation

For now the only place for documentation is project spec directory


## Questions

1. What is the size of one package send from client to server?

Redis client communicate with redis server using RESP protocol, and sends the message using TCP. So to find out what is the size of the package
we must take into consideration several factors:
- **A** is size of package itself (in our case its json string)
- **B** is package destination (queue name), type of operation (lpush) and RESP specifics (encoding)
- **C** is related to details of communication protocol (headers, connection establishment, etc)

If we assume that our message will consist only ASCII characters, then every character from **A** will cost us 1 byte. For example package like this
`{ bike_id: 1, message: 690_characters_length }.to_json`
will take 716 bytes.

Not going in to deep details about protocol I've investigated that **B** in our case takes 38 bytes (using redis info command and `total_net_input_bytes` value).

Using wireshark I've checked that **C** will be about 450 bytes (summing all traffic from our client to redis server).

To sum up - sample package send from client to redis server will have about 716+38+450=**1204 bytes** assuming that we talking about data upload from the client.

2. Image that this message is a status update from our bike to server and your client application is our bike client. Knowing that we have a limit of 8 MB per bike per month (month is always 31 days
   long) calculate how many messages can we send per day, in a way that we do not go above limit and we send at least 2 messages per day.

If answer on previous question is correct then we shouldn't get into troubles with this limit, because ((8*1024*1024)/1204)/31 will give us about *224 message* per day.

However if we get into trouble with upload limit we could reduce size of package by:
- message compression (i.e. Zlib but CPU will have more work),
- compacting parameters names, name of queue, changing json to simpler structure,
- maybe redis pipelining will cut off something from things related to **C** from previous point.

3. What is the best strategy/setup for test environment for this client/server application. Describe the setup, and libraries
 that you would like to use in order to fully test it, remember that 100% test coverage does not always mean that application is well tested.

I think that in general test coverage in only showing some trends, and can't be treated as fundamental quality measure. What is also worth to mention
that always will be some scenarios than no one predicted.

So we may think that it would be great to have test environment as much similar to production one as it is possible. Then we could play with it and try to
screw it up as much as we can before it goes to client. But when when architecture grows and in place of two services we get 2 hundreds, then cost of its maintenance will be tremendous.

That's why in my opinion the most important thing is to supervise the production environment (send unhandled errors to services like rollbar and notify it about scenarios that require more attention) and make sure that
contracts between services are valid (i.e. for json there is great json-schema gem, i would use it on both contractors), monitor servers health (like CloudWatch or new relic), look over process (god).
We can also find information about things that seems crazy - like in netflix where they're using chaos monkey to checkout robustness of their systems (hard day at work but maybe free nights and weekend in exchange).

There is also trend to run some tests that cover critical paths of our system in production environment (tools like new relic sythetics). This kind of tests should be focused on user scenarios running on highest possible level.

To sum up thoughts mentioned above - i would prefer production monitoring over expensive test environment.

But of course provided integration tests are too simple. There is lack of checking basic failures like connection problems (maybe result of that would be use of BRPOPLPUSH command) or loosing connection at all (make sure that we will be notified about not responding for some time period).

What i would do:
- implement contract validation
- integration test for connection problems (timecop, webmock)
- feature test with put_on_queue call from test (so the mock of real bike) and checking out if we got this on page (capybara to be more expressive)
- integration test without response from redis (check if there will be notification about this)
- if i had architecture with dozens of services using redis, i would test sample one with killing redis to implement things like redis sentinel
- i would also try to connect real bike device to production network (with some special identifier to recognize its testing purpose), without limitation for uploading data,
 which sends update message often (every 5 second, 5 minute etc), and after deployment i would run functional test (with capybara outside rails project - only production test suite, or using tool like syntethics) to check if its status update are visible on page.

