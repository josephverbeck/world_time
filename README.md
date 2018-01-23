# README

##To stand up
```bash
$ bundle install
```
then
```bash
$ rails s
```

## Configuration and Requirements
* Ruby version: 2.4.1

* System dependencies
     * mongoDB
     * Google Maps Api key

* Configuration
    * Two environment variables are required for production environment
       * ENV["GOOGLE_API_KEY"]
       * ENV['MONGODB_URI']
            * mongodb://{username}:{password}@host:port/dbname
