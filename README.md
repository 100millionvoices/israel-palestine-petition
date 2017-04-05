# README

* You will need ruby 2.3
* You will need PostgreSQL
* To view signatures by country you will need to run `rake db:seed`

## How to run the test suite

We use rspec so to run tests use the command:

`bin/rspec`

## GeoIP location

We are using geoip data from http://dev.maxmind.com/geoip/geoip2/geolite2/. The data file location is set in `.env.development`. Create this file by copying `.env.development.example`.

## Google reverse geocoding

In order to display a pre-populated place name, we use GeoIP data as described above. However, if the place name is not in the user's preferred locale, we use a google API for reverse geocoding (from lat/lng to location name). A Google API key is stored in `.env.development`.

## Google reCAPTCHA

The reCAPTCHA sitekey and secret are held in `.env.development`. You need to create them from https://www.google.com/recaptcha/intro/invisible.html.

## Email previews

These can be viewed at http://localhost:3000/rails/mailers/.

## Thanks

We have borrowed shamelessly from https://github.com/alphagov/e-petitions. Thank you to @alphagov, @ubxd and all the gem authors. Your work is much appreciated.
