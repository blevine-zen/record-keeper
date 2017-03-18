require 'date'
require 'rack/test'

require_relative '../lib/api'
require_relative '../lib/record_collection'
require_relative '../lib/record'

MATT_HASH = { last_name: 'Bellamy',
              first_name: 'Matt',
              favorite_color: 'Red',
              date_of_birth: '1978-06-09' }.freeze
CHRIS_HASH = { last_name: 'Wolstenholme',
               first_name: 'Chris',
               favorite_color: 'Green',
               date_of_birth: '1978-12-02' }.freeze
DOMINIC_HASH = { last_name: 'Howard',
                 first_name: 'Dominic',
                 favorite_color: 'Blue',
                 date_of_birth: '1977-12-07' }.freeze
