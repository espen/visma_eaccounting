# visma_eaccounting

VismaEaccounting is an API wrapper for the Visma eAccounting [API](https://developer.vismaonline.com/).

## Important Notes

VismaEaccounting returns a `VismaEaccounting::Response` instead of the response body directly. `VismaEaccounting::Response` exposes the parsed response `body` and `headers`.

## Installation

    $ gem install visma_eaccounting

## Requirements

A Visma eAccounting account and oAuth client id.

## Usage

First, create a *one-time use instance* of `VismaEaccounting::Request`:

```ruby
visma_eaccounting = VismaEaccounting::Request.new(token: "your_token")
```

***Note*** Only reuse instances of VismaEaccounting after terminating a call with a verb, which makes a request. Requests are light weight objects that update an internal path based on your call chain. When you terminate a call chain with a verb, a request instance makes a request and resets the path.

You can set an individual request's `timeout` and `open_timeout` like this:

```ruby
visma_eaccounting.timeout = 30
visma_eaccounting.open_timeout = 30
```

You can read about `timeout` and `open_timeout` in the [Net::HTTP](https://ruby-doc.org/stdlib-2.3.3/libdoc/net/http/rdoc/Net/HTTP.html) doc.

Now you can make requests using the resources defined in [the Visma eAccounting's docs](https://developer.vismaonline.com/#APIReference). Resource IDs
are specified inline and a `CRUD` (`create`, `retrieve`, `update`, `upsert`, or `delete`) verb initiates the request. `upsert` lets you update a record, if it exists, or insert it otherwise where supported by Visma's API.

You can specify `headers`, `params`, and `body` when calling a `CRUD` method. For example:

```ruby
visma_eaccounting.customers.retrieve(headers: {"SomeHeader": "SomeHeaderValue"}, params: {"query_param": "query_param_value"})
```

Of course, `body` is only supported on `create` and `update` calls. Those map to HTTP `POST` and `PUT` verbs respectively.

You can set `token`, `timeout`, `open_timeout`, `faraday_adapter`, `proxy`, `symbolize_keys`, `logger`, and `debug` globally:

```ruby
VismaEaccounting::Request.token = "your_token"
VismaEaccounting::Request.timeout = 15
VismaEaccounting::Request.open_timeout = 15
VismaEaccounting::Request.symbolize_keys = true
VismaEaccounting::Request.debug = false
```

For example, you could set the values above in an `initializer` file in your `Rails` app (e.g. your\_app/config/initializers/visma_eaccounting.rb).

Assuming you've set an `token` on VismaEaccounting, you can conveniently make API calls on the class itself:

```ruby
VismaEaccounting::Request.customers.retrieve
```

***Note*** Substitute an underscore if a resource name contains a hyphen.

Pass `symbolize_keys: true` to use symbols (instead of strings) as hash keys in API responses.

```ruby
visma_eaccounting = VismaEaccounting::Request.new(token: "your_token", symbolize_keys: true)
```

Visma's [API documentation](https://developer.vismaonline.com/#APIReference) is a list of available endpoints.

## Environments

The default environment is ```:production```. To use the sandbox environment you can set ```:sandbox``` in constructor or globally. This will set the default ```api_endpoint``` URL.

## Debug Logging

Pass `debug: true` to enable debug logging to STDOUT.

```ruby
visma_eaccounting = VismaEaccounting::Request.new(token: "your_token", debug: true)
```

### Custom logger

Ruby `Logger.new` is used by default, but it can be overrided using:

```ruby
visma_eaccounting = VismaEaccounting::Request.new(token: "your_token", debug: true, logger: MyLogger.new)
```

Logger can be also set by globally:

```ruby
VismaEaccounting::Request.logger = MyLogger.new
```

## Examples

### Customers

Fetch all customers:

```ruby
visma_eaccounting.customers.retrieve
```

By default the Visma API returns 50 results. To set the count to 50:

```ruby
visma_eaccounting.customers.retrieve(params: {"pagesize": "100"})
```

And to retrieve the next 50 members:

```ruby
visma_eaccounting.customers.retrieve(params: {"pagesize": "100", "page": "2"})
```

Query using filters:

```ruby
visma_eaccounting.customers.retrieve(params: {"filter": "contains(Name, ‘MakePlans’)"})
```

Retrieving a specific customer looks like:

```ruby
visma_eaccounting.customers(customer_id).retrieve
```

Add a new customer:

```ruby
visma_eaccounting.customers.create(body: {"Name": "MakePlans AS"})
```

### Fields

Only retrieve ids and names for fetched customers:

```ruby
visma_eaccounting.customers.retrieve(params: {"select": "Id, Name"})
```

### Error handling

VismaEaccounting raises an error when the API returns an error.

`VismaEaccounting::VismaEaccountingError` has the following attributes: `title`, `detail`, `body`, `raw_body`, `status_code`. Some or all of these may not be
available depending on the nature of the error. For example:

```ruby
begin
  visma_eaccounting.customers(customer_id).members.create(body: body)
rescue VismaEaccounting::VismaEaccountingError => e
  puts "Houston, we have a problem: #{e.message} - #{e.raw_body}"
end
```

### Other

You can set an optional proxy url like this (or with an environment variable VISMA_PROXY):

```ruby
visma_eaccounting.proxy = 'http://your_proxy.com:80'
```

You can set a different [Faraday adapter](https://github.com/lostisland/faraday) during initialization:

```ruby
visma_eaccounting = VismaEaccounting::Request.new(token: "your_token", faraday_adapter: :net_http)
```

#### Initialization

```ruby
visma_eaccounting = VismaEaccounting::Request.new(token: "your_token")
```

## Thanks

Thanks to everyone who has [contributed](https://github.com/espen/visma_eaccounting/contributors) to VismaEaccounting's development.

## Credits

Based on [Gibbon](https://github.com/amro/gibbon) by [Amro Mousa](https://github.com/amro).

## Copyright

* Copyright (c) 2010-2017 Espen Antonsen and Amro Mousa. See LICENSE.txt for details.