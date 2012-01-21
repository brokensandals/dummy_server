This is a generic mock web server.

Use its web interface to create one or more rules - regexes for matching request path and HTTP method. The server will respond to requests that match the rules with response status, headers, and body specified by you, and will record the requests for inspection.

The steps below will start the server at http://localhost:3000

    gem install bundler
    bundle install
    rake db:create
    rake db:migrate
    rails server

Tested on Ruby 1.9.3-preview1.

# TODO

* Record and display non-textual request bodies gracefully
* Allow arbitrary logic to be specified for generating responses
* Automatically delete hit records after a time or quantity threshold