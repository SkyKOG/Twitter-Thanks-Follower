![](http://i.imgur.com/iMn1hQz.jpg)

# Thank your followers

This is a small ruby script which allows you to send a direct message to your followers, thanking them for following you !!!.

## Dependencies

    gem install 'twitter'
    gem install 'json'
    gem install 'redis'

## Working

After setting up your access credentials and twitter handle. Initialise the redis store with the data of your current followers by running `setup_old_followers`.

On consequest runs, new followers are fetched, thanked via DM and updated in the redis store.

You can automate this via sidekiq/cron.

## Features

* Persistent data storage using redis.
* Multiple uses support (by just changing the twitter handle, multiple data stores are managed).
* JSON/Twitter object/ Ruby hash formats

## Todo

* OmniAuth integration.
* Sidekiq integration.

## Credits

Mentored under [Nidhi Sarvaiya](https://twitter.com/sarvaiya_nidhi).

## License

Available under the MIT License.
