# Europeana Radio Station

[![Build Status](https://travis-ci.org/europeana/radio-station.svg?branch=develop)](https://travis-ci.org/europeana/radio-station) [![Coverage Status](https://coveralls.io/repos/github/europeana/radio-station/badge.svg?branch=develop)](https://coveralls.io/github/europeana/radio-station?branch=develop) [![security](https://hakiri.io/github/europeana/radio-station/develop.svg)](https://hakiri.io/github/europeana/radio-station/develop)

Broadcasting playlists of tunes from the Europeana collections.

For a player ready to work with these playlists, see the
[Europeana Radio Player](https://github.com/europeana/radio-player).

## Requirements

* Ruby 2.3.1
* PostgreSQL
* Redis
* [Europeana API key](http://labs.europeana.eu/api/registration)

## Installation

1. Clone the repo: `git clone https://github.com/europeana/radio-station.git`
2. Install the bundle: `cd radio-station && bundle install`
3. Create a PostgreSQL database, and a Redis database

## Configuration

Europeana Radio is configured through environment variables. Set the following
to configure your installation:

### Data stores
* `DATABASE_URL`: the URL to your PostgreSQL database, e.g.
  `DATABASE_URL=postgres://postgres@localhost/europeana_radio?pool=10`
* `REDIS_URL`: the URL to your Redis database, e.g.
  `REDIS_URL=redis://localhost:6379/1`

### APIs
* `EUROPEANA_API_KEY`: your API key for the Europeana Search API, e.g.
  `EUROPEANA_API_KEY=mykey123`
* `EUROPEANA_ANNOTATIONS_API_KEY`: your API key for the Europeana Annotations
  API, e.g. `EUROPEANA_ANNOTATIONS_API_KEY=myotherkey456`
* `EUROPEANA_ANNOTATIONS_API_USER_TOKEN`: your API user token for writing to the
  Europeana Annotations API, e.g. `EUROPEANA_ANNOTATIONS_API_KEY=token789`

### Scheduling
* `SCHEDULE_PLAYLIST_REFRESH`: the time each day to shuffle station playlists,
  e.g. `SCHEDULE_PLAYLIST_REFRESH="03:15"`
* `SCHEDULE_TUNES_REFRESH`: the time each week to refresh from the API the
  tunes on each station's playlist, e.g. `SCHEDULE_TUNES_REFRESH="Sunday 04:20"`
* `SCHEDULE_ORIGINS_REFRESH`: the time each week to update/delete all harvested
  record metadata from the API, e.g. `SCHEDULE_ORIGINS_REFRESH="Saturday 02:27"`

In a development environment, you can take advantage of dotenv to set
environment variables in the file named ".env".

## Database initialisation

1. Create the database schema: `bundle exec rake db:schema:load`
2. Seed it: `bundle exec rake db:seed`

## Boot it up

Europeana Radio needs to run three separate application instances: a web server,
a background job processor, and a background job scheduler.

The commands for each of these are in [Procfile](Procfile), and in development
can all be run with the one command `foreman start`.

You should now be able to get a list of stations at http://localhost:5000/stations.json.
A number of stations are supplied by default (see [db/seeds/rb](db/seeds.rb)),
but they will not have any tracks on their playlist at first.

Sample response:
```json
{
  "stations": [{
    "name": "Classical Music",
    "link": "http://radio.europeana.eu/stations/genres/classical.json",
    "totalResults": 1886,
    "totalPlays": 238
  }, {
    "name": "Folk and Traditional Music",
    "link": "http://radio.europeana.eu/stations/genres/folk.json",
    "totalResults": 369,
    "totalPlays": 73
  }]
}
```

## Populate the playlists

With the application instances running, execute the following to start off a
series of background jobs to populate each station's playlist:

`bundle exec rails runner -e production 'Station.find_each { |s| RefreshStationTunesJob.perform_later(s.id) }'`

Tracks will not become available until the entire playlist has been constructed,
which involves many API queries and so could take a long while on the first run.

Once per day, the scheduler will trigger the playlists to be randomised, 
and once per week to be refreshed, picking up any changes to the tracks
available for each station. A separate scheduled job will update or delete
metadata for all harvested tunes.

## Get track(s) from a playlist

To get track(s) from a playlist, visit the station's URL, e.g.
http://localhost:5000/stations/genres/classical.json

The response will contain a list of tracks, each with a URL to the audio and
a set of metadata.

Tracks in the playlist are paginated with the URL parameters:

* `start`: first track to retrieve, default 1; setting this higher than the total
  number of tracks will loop back to the start
* `rows`: number of tracks to retrieve, default 12, max 100

Sample response:
```json
{
  "station": {
    "name": "Classical Music",
    "link": "http://radio.europeana.eu/stations/genres/classical.json",
    "totalResults": 3732,
    "playlist": [{
      "audio": "http://radio.europeana.eu/tunes/8b8a9504-194b-4c65-a21a-0ade3c149736/play?station_id=1",
      "title": "A moonlight song / (Mills-Cadman)",
      "creator": "Cadman, Charles Wakefield",
      "thumbnail": "https://www.europeana.eu/api/v2/thumbnail-by-url.json?type=SOUND\u0026uri=http%3A%2F%2Fmedia.slub-dresden.de%2Ffon%2Fsnp%2Fb%2F006422%2Ffon_snp_b_006422_01_hp.jpg",
      "europeanaId": "/2048401/item_ZPVBZEGGAGYPUNJDEJRVS6FF4XRUAU7A",
      "copyright": "http://rightsstatements.org/vocab/InC/1.0/",
      "mimeType": "audio/mpeg",
      "fileByteSize": 602384,
      "duration": "30119",
      "sampleRate": 22050,
      "bitRate": 160000,
      "annotations": "http://radio.europeana.eu/tunes/8b8a9504-194b-4c65-a21a-0ade3c149736/annotations.json"
    }, {
      "audio": "http://radio.europeana.eu/tunes/9693eb59-2a16-41b6-b1b0-207507836df5/play?station_id=1",
      "title": "Jūriņ prasa smalku tīklu",
      "creator": "National Library of Latvia",
      "thumbnail": "https://www.europeana.eu/api/v2/thumbnail-by-url.json?type=SOUND\u0026uri=http%3A%2F%2Fdom.lndb.lv%2Fdata%2Fobj%2F54418.png",
      "europeanaId": "/2059201/data_sounds_54418",
      "copyright": "Public Domain Marked",
      "mimeType": "audio/mpeg",
      "fileByteSize": 2542848,
      "duration": "158928",
      "sampleRate": 48000,
      "bitRate": 128000,
      "annotations": "http://radio.europeana.eu/tunes/9693eb59-2a16-41b6-b1b0-207507836df5/annotations.json"
    }]
  }
}
```

## Tests

Tests are written in MiniTest. After configuring and initialising a test
PostgreSQL database, run `bundle exec rake`.

## License

Licensed under the EUPL V.1.1.

For full details, see [LICENSE.md](LICENSE.md).
