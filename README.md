# Project Backend

## Installation

Install all the requirement for the app

### 1. Ruby

Install ruby version `2.6.3`

For Windows: https://rubyinstaller.org/downloads/
Download and install from above link

### 2. Postgres

Install Postgres Sql 10.8
For Windows: https://www.enterprisedb.com/downloads/postgres-postgresql-downloads

**Important! Set Password: `postgres`**
**Note: Add to PATH environment variable**

## Setup

After all the installation completes we need to setup the app.
Open ruby 2.6.3 command prompt on windows and run the following

Download and unpack all the dependent gems
```
bundle install
```

DB Setup
```
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed
```

Run the server

```
rails s
```
