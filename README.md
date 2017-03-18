## Synopsis

Contained is a system built to parse and sort a set of records. A record is an object that contains some personal information regarding a person, specifically their name, date of birth, and favorite color.

## Installation

This project requires that Grape, rack-test, and rspec gems are installed  

## API Reference

The API is powered by Grape, and the server can be started by running `rackup` while in `/record-keeper`.

The following methods are provided:

[POST /records] (localhost:9292/records) - Posts a single line of data formatted either as a comma or pipe delimited string, which is then saved into the makeshift text file database. The parameter key for this method is `record`, and the value is the formatted string.

[GET /records/birthdate] (localhost:9292/records/birthdate) - Returns a list of records sorted by birthdate in ascending order.

[GET /records/name] (localhost:9292/records/name) - Returns a list of records sorted by last name in descending order.

Data is stored in a text file under `/record-keeper/data`. Some data has been provided to start, but the entire data folder can be removed and will be recreated when an initial record is posted.

## Tests

Tests are written using RSpec. The entire suite can be ran by navigating to `/record-keeper/spec` and running `rspec`.
