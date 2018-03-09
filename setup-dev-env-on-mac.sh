#!/bin/sh
set -e
# reference:  http://www.fngtps.com/2016/rails-development-environment/

RUBY_VERSION="2.3.0"
set -x

brew update
brew install rbenv ruby-build
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
eval "$(rbenv init -)"
rbenv install ${RUBY_VERSION}
# always run this after installing a Gem that includes one or more command line tools
rbenv rehash
rbenv versions
rbenv global ${RUBY_VERSION}
set +x
echo 'Now using the following ruby:'
set -x
ruby -v
gem install bundler
brew install ffmpeg
brew install ffmpegthumbnailer
brew install imagemagick
brew install postgres
brew services start postgres
brew install redis
brew services start redis

# this may fail if java is not installed yet
# to remove this brew install elasticsearch - Install specific elasticsearch version
brew install homebrew/versions/elasticsearch23
brew services start elasticsearch

set +x
echo 'Make sure:'
echo '   postgresql is running'
echo '   create a postgres user that has permission to create database'
echo '   elasticsearch is running'
echo 'Now, go to source the code folder and do the followings:'
echo '   create a file db/database.yml base on db/database_example.yml and use the db user created above'
echo '   bundler install'
echo '   rake db:create'
echo '   rake db:migrate'
echo '   rake searchkick:reindex CLASS=Product'
echo '   rake db:seed'
echo 'Run server with: rails s'
