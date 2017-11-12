[![Gem Version][gem]][gem-url]
[![test][test]][test-url]
[![coverage][cover]][cover-url]

# JsonRoutesWebpack

Exports Rails named routes to JSON that can be loaded in Javascript via webpack loaders like [js-routes-loader](https://github.com/Alignable/js-routes-loader)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'json_routes_webpack'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install json_routes_webpack

## Usage

### Add a Rails initializer

Add an initializer that configures the routes you want to export and the file to write them too

**config/initializers/json_routes_webpack.rb**
```ruby
JsonRoutesWebpack.configure do |config|
  config.add_routes 'app/javascript/generated/routes.json'
end
```

In addition to the file name to write the routes `add_routes` supports two options arguments
* `include` - an array of regular expressions the route name must match to be included
* `exclude` - an array of regular expression tht the route name must not match

Example: suppose you wanted to export you app and admin routes to separate files
```ruby
JsonRoutesWebpack.configure do |config|
  config.add_routes 'app/javascript/routes/routes.json', exclude: [/admin/]
  config.add_routes 'app/javascript/routes/admin_routes.json', include: [/admin/]
end
```

### Configure Rake to build json routes before Webpacker compiles

We need the json routes to be available to webpack loaders add a rake hook to build the routes before Webpacker compiles our javascript

**lib/tasks/js_routes.rake**
```ruby
# generate json routes before webpacker so they can be used by loaders
if Rake::Task.task_defined?("webpacker:compile")
  Rake::Task["webpacker:compile"].enhance ["json_routes_webpack:compile"]
end
```

### Install `js-routes-loader` and configure Webpacker to use it for routes json files

```bash
$ yarn add js-routes-loader
```

**config/webpack/environment.js**
```javascript
const { environment } = require('@rails/webpacker');

environment.loaders.set('js-routes', {
  test: /routes\.json$/,
  use: 'js-routes-loader',
});

module.exports = environment;
```


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[gem]: https://badge.fury.io/rb/json_routes_webpack.svg
[gem-url]: https://badge.fury.io/rb/json_routes_webpack

[test]: http://img.shields.io/travis/Alignable/json_routes_webpack.svg
[test-url]: https://travis-ci.org/Alignable/json_routes_webpack

[cover]: https://codecov.io/gh/Alignable/json_routes_webpack/branch/master/graph/badge.svg
[cover-url]: https://codecov.io/gh/Alignable/json_routes_webpack
