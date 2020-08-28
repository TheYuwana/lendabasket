# Frontend assignment

The goal is to implement an investment selection process.

A selection of one or more offers to invest in consists of an `Order`. The required data to create an `Order` needs to be sent to a REST compliant controller in agreement with the [JSON API specifications](https://jsonapi.org).

The following restrictions need to be considered:

1. It should not be possible to invest more than the difference between the target and what is currently funded.
2. It is possible that the available funding changes in the time it takes for a user to create their order up until it is submitted to the server. In this case the server will return an error message according to JSON API specification. See example below. Any error occurring needs to be presented to the user.

Don't spend too much time on how it looks. What's more important is that the code is up to standards and there are no glaring issues.

## User story

As a user

- I see a list of available investment offers with the attributes as listed in `lib/fixtures/offers.json`.
- I am able to select an amount for any of the available offers
- I can see that I have selected an amount at all times
- I have the option to make the payment now or add more investments
- I am able to adjust the investment amount
- After chosing to pay now I am able to select a payment method (ideal or credit card)
- If the investment is successful I see a confirmation
- If the the investment did not go through, I will see an error message

## Getting started

1. Make sure [Ruby 2.7.0 or higher is installed](https://www.ruby-lang.org/en/documentation/installation/).
3. run `yarn install`
3. run `bundle install`
4. To run the server: `bundle exec rails s`

### Adding a frontend framework (optional)

If you like, you can add your chosen framework with the `rails webpacker:install` command.

For available webpacker commands: `rake -T | grep webpacker`

If you want to do it another way, that's completely fine.

## References

### Example of expected body for creating the `Order`

```json
{
  "data": {
    "type": "order",
    "attributes": {
      "currency": "EUR",
      "payment_method": "ideal",
      "investments": {
        "32": 150
      }
    }
  }
}
```

### JSON API response in case of success

head:

```
201
```

body:

```json
{
  "data": {
    "id": "32",
    "type": "order",
    "attributes": {
      "currency": "EUR",
      "investor_id": 14621,
      "payment_method": "ideal",
      "reference": "70222949cc0db89ab32c9969754d4758",
      "status": "initialized",
    },
    "relationships": {
      "investments": {
        "data": [
          {
            "id": "1157",
            "type": "investment"
          }
        ]
      }
    }
  }
}

```

### JSON API response in case of error

body:

```json
{
  "errors": [
    {
      "status": "Unprocessable Entity",
      "code": 422,
      "title": "Project unavailable",
      "details": "One of your investments is for a project that is unavailable. Please check if any project has fulfilled its target funding."
    }
  ]
}
```
