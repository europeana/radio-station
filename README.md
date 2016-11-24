# Europeana Radio Station

[![Build Status](https://travis-ci.org/europeana/radio-station.svg?branch=develop)](https://travis-ci.org/europeana/radio-station) [![Coverage Status](https://coveralls.io/repos/github/europeana/radio-station/badge.svg?branch=develop)](https://coveralls.io/github/europeana/radio-station?branch=develop) [![security](https://hakiri.io/github/europeana/radio-station/develop.svg)](https://hakiri.io/github/europeana/radio-station/develop) [![Dependency Status](https://gemnasium.com/europeana/radio-station.svg)](https://gemnasium.com/europeana/radio-station)

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

* `DATABASE_URL`: the URL to your PostgreSQL database, e.g.
  `DATABASE_URL=postgres://postgres@localhost/europeana_radio?pool=10`
* `REDIS_URL`: the URL to your Redis database, e.g.
  `REDIS_URL=redis://localhost:6379/1`
* `EUROPEANA_API_KEY`: your API key for the Europeana Search API, e.g.
  `EUROPEANA_API_KEY=mykey123`
* `SCHEDULE_PLAYLIST_REFRESH`: the time each day to refresh station playlists,
  e.g. `SCHEDULE_PLAYLIST_REFRESH="03:15"`
* `SCHEDULE_INSTITUTION_REFRESH`: the time each day to refresh the set of
  institutions, e.g. `SCHEDULE_INSTITUTION_REFRESH="02:45"`

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
The supplied stations are _Classical_ and _Folk_, but they will not have any
tracks on their playlist at first.

Sample response:
```json
{
  "stations": [{
    "name": "Classical Music",
    "link": "http://localhost:5000/stations/classical.json",
    "totalResults": 1886
  }, {
    "name": "Folk and Traditional Music",
    "link": "http://localhost:5000/stations/folk.json",
    "totalResults": 369
  }]
}
```

## Populate the playlists

With the application instances running, execute the following to start off a
series of background jobs to populate each station's playlist:

`bundle exec rails runner -e production 'Station.find_each { |s| RefreshStationPlaylistJob.perform_later(s.id) }'`

Tracks will not become available until the entire playlist has been constructed,
which involves many API queries and so could take a while on the first run.

Once per day, the scheduler will trigger the playlists to be refreshed, picking
up any new tracks for each station, and updating metadata if it has changed.
While this is taking place, the existing playlist will remain available.

## Get track(s) from a playlist

To get track(s) from a playlist, visit the station's URL, e.g.
http://localhost:5000/stations/classical.json

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
    "link": "http://localhost:5000/stations/classical.json",
    "totalResults": 1886,
    "playlist": [{
      "audio": "http://media.slub-dresden.de/fon/snp/a/008768/fon_snp_a_008768_01.mp3",
      "title": "Mignon / Auswahl",
      "creator": "Thomas, Ambroise",
      "thumbnail": "https://www.europeana.eu/api/v2/thumbnail-by-url.json?uri=http%3A%2F%2Fmedia.slub-dresden.de%2Ffon%2Fsnp%2Fa%2F008768%2Ffon_snp_a_008768_01.jpg",
      "europeanaId": "/2048401/item_ZTDOX5XZGY5OUEMZQGDT3KMXZF6AQ2OH",
      "copyright": "Rights reserved - Free access",
      "mimeType": "audio/mpeg",
      "fileByteSize": 3869780,
      "duration": "193489",
      "sampleRate": 22050,
      "bitRate": 160000
    }, {
      "audio": "http://media.slub-dresden.de/fon/snp/a/000401/fon_snp_a_000401_01.mp3",
      "title": "Die Meistersinger von Nürnberg \u0026lt;Morgenlich leuchtend\u0026gt;",
      "creator": "Wagner, Richard",
      "thumbnail": "https://www.europeana.eu/api/v2/thumbnail-by-url.json?uri=http%3A%2F%2Fmedia.slub-dresden.de%2Ffon%2Fsnp%2Fa%2F000401%2Ffon_snp_a_000401_01.jpg",
      "europeanaId": "/2048401/item_2KAXD64DAWBKMDVSYVHYUXAQ5LKBJOQM",
      "copyright": "Rights reserved - Free access",
      "mimeType": "audio/mpeg",
      "fileByteSize": 4807053,
      "duration": "240352",
      "sampleRate": 22050,
      "bitRate": 160000
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
