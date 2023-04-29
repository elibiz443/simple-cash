# SIMPLE-CASH

This is an API that helps users to register and send money to each other within the system. They also get to top up the amounts through MPESA, for demo purposes, they'll also be able totop-up manually through a section where they enter the number and amount. Once a transfer is done, the recipient receives a notification in the system as well as confirmation through email. The user is also able to trigger an email report summarising all the transactions they have done for the selected number of days.

### Steps to run the app:
```
git clone git@github.com:elibiz443/simple-cash.git && bundle && rails db:create db:migrate db:seed

```

### The making of the app:

1. Create a new web application:

I start by runing in terminal:
```
rails new simple-cash -d postgresql --api -T && cd simple-cash
```
I do this so as to generate rails 7 API skeleton.

Requirements:
* postgresql as the database for Active Record.
* Ruby version 3.2.0
* Rails version 7.0.4
* Doesn't use the default Minitest for testing coz I will be using RSpec.


i) Addind RSpec:

In Gemfile, add:
```
group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "rspec-rails"
  gem "factory_bot_rails", :require => false
  gem "faker"
  gem "database_cleaner-active_record"
end
```
In Terminal, Run:
```
bundle && rails g rspec:install
```

Create these folder and files, through running the following in terminal(in our app directory):
```
mkdir spec/support && touch spec/support/factory_bot.rb && touch spec/factories.rb
```

Configure FactoryBot by adding:
```
# spec/support/factory_bot.rb

require 'factory_bot'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  FactoryBot.find_definitions
end
```

Require support files in rails_helper.rb:
```
require_relative 'support/factory_bot'
```

In rails_helper.rb, uncomment:
```
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }
```
When User model is generated (or any model) RSpec will generate a factory in factories.rb file. Modify it to look like:
```
# spec/factories.rb

FactoryBot.define do
end
```

Run Tests with:
```
rspec
```

API Endpoints:
```
https://simplecash.herokuapp.com
```

#### Published API Documentation Link:
```
https://documenter.getpostman.com/view/5291351/2s93eSYv8g
```
