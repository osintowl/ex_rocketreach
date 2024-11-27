# ex_rocketreach

An Elixir client library for the RocketReach API, providing easy access to professional and company contact information.

## Installation

Add `ex_rocketreach` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_rocketreach, "~> 0.1.2"}
  ]
end
```

## Usage

### Basic Setup

```elixir
# Create a new client with your API key
client = RocketReach.new("your_api_key")
```

### Person Lookup and Search

```elixir
# Look up a person by parameters
{:ok, person} = RocketReach.lookup_person(client, %{
  email: "example@company.com"
})

# Search for people
{:ok, results} = RocketReach.search_people(client, %{
  query: %{
    current_employer: ["example.com"],
    management_levels: ["C-Level", "VP"]
  }
})
```

### Company Information

```elixir
# Look up company details
{:ok, company} = RocketReach.lookup_company(client, %{domain: "example.com"})

# Get company tech stack
{:ok, tech_stack} = RocketReach.get_company_tech_stack(client, "example.com")
```

### Organization Structure

```elixir
# Get company org chart
{:ok, org_chart} = RocketReach.get_org_chart(client, "example.com")

# Get leadership team
{:ok, leaders} = RocketReach.get_leadership_team(client, "example.com")
```

## Features

- Person lookup and search
- Company information retrieval
- Technology stack analysis
- Organization structure mapping
- Department-wise employee search
- Leadership team identification
- Bulk lookup operations

## Documentation

Full documentation can be found at [https://hexdocs.pm/ex_rocketreach](https://hexdocs.pm/ex_rocketreach).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create new Pull Request

