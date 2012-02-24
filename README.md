# Dependencies

Resto-Net depends on [MongoDB](http://www.mongodb.org/) and [ElasticSearch](http://www.elasticsearch.org/).

# Getting Started

    git clone git://github.com/opennorth/resto-net-national.git
    cd resto-net-national
    bundle
    bundle exec rake db:setup
    bundle exec rake data:montreal:import
    bundle exec rake data:toronto:update
    bundle exec rake data:vancouver:import

# Updating Data

    bundle exec rake cron

# Deployment

[Create a Heroku account](http://heroku.com/signup) and setup SSH keys as described on [Getting Started with Heroku](http://devcenter.heroku.com/articles/quickstart).

    gem install heroku
    heroku create --stack cedar APP_NAME
    git push heroku master
    heroku db:push
    heroku addons:add custom_domains:basic
    heroku addons:add logging:expanded
    heroku addons:add pgbackups:auto-month
    heroku addons:add releases:basic
    heroku addons:add cron:daily
    heroku addons:add logging:expanded
