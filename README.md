# Payment Application

## Creating Users
### Admin
To create admin you can run:

`bundle exec rake import:admins`.

It uses a CSV file `admins.csv` you can edit it to create admin of you choice.
### Merchant
To create merchant you can run:

`bundle exec rake import:merchants`.

It uses a CSV file `merchants.csv` you can edit it to create admin of you choice.

## Postman collection
A postman collection (`payment_app.postman_collection.json`) is kept in this repository to describe user authentication and different type of transaction creation.

## UI
We need to login via a admin user and then we can check the mechants and thier transaction. We can also perform some operations on those.

## Running the test cases
`bundle exec rspec spec`

### Process to run the app

* Make sure you have ruby '3.2.0'
you can install it by `rvm install ruby-3.2.0`
* clone repo
* `cd payment_application`
* run `bundle`
* create and migrate database `rails db:create && rails db:migrate`
* to run the server `rails s`
