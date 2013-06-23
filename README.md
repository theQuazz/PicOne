# PicOne #

API / Web interface for the PicOne app

### Installation Instructions ###

Get postgres! (or use MySQL in development I suppose)

      $ git clone git@github.com:theQuazz/PicOne
      $ cd PicOne
      $ bundle install
      $ rake db:create db:migrate
      $ rails s

now you should be up and running on port 3000!
