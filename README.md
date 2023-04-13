# SIMPLE-CASH

This is an API that helps users to register and send money to each other within the system. They also get to top up the amounts through MPESA, for demo purposes, they'll also be able totop-up manually through a section where they enter the number and amount. Once a transfer is done, the recipient receives a notification in the system as well as confirmation through email. The user is also able to trigger an email report summarising all the transactions they have done for the selected number of days.

### Steps to run the app:
```
git clone git@github.com:elibiz443/simple-cash.git
bundle
rails db:create db:migrate db:seed && rails s
localhost:3000(in browser)
```

### The making of the app:

In gemfile, Add:
