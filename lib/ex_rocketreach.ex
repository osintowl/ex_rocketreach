defmodule RocketReach do
  @moduledoc """
  Client for the RocketReach API.
  Provides functions to search and lookup contact information for professionals and companies.

  This module offers comprehensive functionality for interacting with the RocketReach API, including:

  ## Core Features
  - Account management and API key creation
  - Person lookup and search capabilities
  - Company information retrieval and search
  - Bulk lookup operations
  - NPI contact search
  - Profile-company lookup

  ## Company-Specific Features
  - Technology stack analysis
  - Competitor analysis
  - Industry information
  - Company growth metrics
  - Company size and revenue search
  - Funding information
  - Location-based company search
  - Public trading status verification
  - Organizational structure analysis

  ## Usage Example
      client = RocketReach.new("your_api_key")
      {:ok, response} = RocketReach.lookup_company(client, %{domain: "example.com"})

  API Reference: https://api.rocketreach.co/api/v2
  """

  @base_url "https://api.rocketreach.co/api/v2"

  @doc """
  Creates a new RocketReach API client with the provided API key.

  ## Parameters
    - api_key: String representing your RocketReach API key

  ## Returns
    - Req struct configured with base URL and API key header
  """
  def new(api_key) do
    Req.new(
      base_url: @base_url,
      headers: [{"Api-Key", api_key}]
    )
  end

  @doc """
  Retrieves account information for the authenticated user.

  ## Parameters
    - client: RocketReach client struct

  ## Returns
    - `{:ok, response}` on success
    - `{:error, reason}` on failure
  """
  def get_account(client) do
    Req.get(client, url: "/account/")
  end

  @doc """
  Creates a new API key for the authenticated account.

  ## Parameters
    - client: RocketReach client struct

  ## Returns
    - `{:ok, response}` containing the new API key
    - `{:error, reason}` on failure
  """
  def create_api_key(client) do
    Req.post(client, url: "/account/key/")
  end

  @doc """
  Looks up detailed information about a person.

  ## Parameters
    - client: RocketReach client struct
    - params: Map of search parameters (e.g., email, name, company)

  ## Returns
    - `{:ok, response}` containing person details
    - `{:error, reason}` on failure
  """
  def lookup_person(client, params) do
    Req.get(client, url: "/person/lookup", params: params)
  end

  @doc """
  Checks the status of multiple person lookups.

  ## Parameters
    - client: RocketReach client struct
    - ids: List of person IDs to check

  ## Returns
    - `{:ok, response}` containing status information
    - `{:error, reason}` on failure
  """
  def check_person_status(client, ids) when is_list(ids) do
    Req.get(client, url: "/person/checkStatus", params: [ids: ids])
  end

  @doc """
  Searches for people based on specified criteria.

  ## Parameters
    - client: RocketReach client struct
    - query: Map containing search criteria

  ## Returns
    - `{:ok, response}` containing search results
    - `{:error, reason}` on failure
  """
  def search_people(client, query) do
    Req.post(client, url: "/person/search", json: query)
  end

  @doc """
  Looks up company information by various parameters.

  ## Parameters
    - client: RocketReach client struct
    - params: Map of company parameters (e.g., domain, name)

  ## Returns
    - `{:ok, response}` containing company details
    - `{:error, reason}` on failure
  """
  def lookup_company(client, params) do
    Req.get(client, url: "/company/lookup/", params: params)
  end

  @doc """
  Searches for companies based on specified criteria.

  ## Parameters
    - client: RocketReach client struct
    - query: Map containing search criteria

  ## Returns
    - `{:ok, response}` containing search results
    - `{:error, reason}` on failure
  """
  def search_companies(client, query) do
    Req.post(client, url: "/searchCompany", json: query)
  end

  @doc """
  Performs bulk lookup operations for multiple queries.

  ## Parameters
    - client: RocketReach client struct
    - queries: List of query parameters
    - opts: Optional keyword list with :profile_list and :webhook_id

  ## Returns
    - `{:ok, response}` containing bulk lookup results
    - `{:error, reason}` on failure
  """
  def bulk_lookup(client, queries, opts \\ []) do
    body = %{
      queries: queries,
      profile_list: Keyword.get(opts, :profile_list, "API Bulk Lookup"),
      webhook_id: Keyword.get(opts, :webhook_id)
    }
    Req.post(client, url: "/bulkLookup", json: body)
  end

  @doc """
  Retrieves contact information for a healthcare provider using NPI number.

  ## Parameters
    - client: RocketReach client struct
    - npi: National Provider Identifier number

  ## Returns
    - `{:ok, response}` containing provider contact information
    - `{:error, reason}` on failure
  """
  def get_npi_contact(client, npi) do
    Req.get(client, url: "/npi/search", params: [npi: npi])
  end

  @doc """
  Looks up profile-company relationship information.

  ## Parameters
    - client: RocketReach client struct
    - params: Map of lookup parameters

  ## Returns
    - `{:ok, response}` containing profile-company information
    - `{:error, reason}` on failure
  """
  def lookup_profile_company(client, params) do
    Req.get(client, url: "/profile-company/lookup", params: params)
  end

  @doc """
  Retrieves the technology stack for a company by domain.

  ## Parameters
    - client: RocketReach client struct
    - domain: Company domain name

  ## Returns
    - `{:ok, tech_stack}` containing list of technologies
    - `{:error, reason}` on failure
  """
  def get_company_tech_stack(client, domain) do
    case lookup_company(client, %{domain: domain}) do
      {:ok, %{body: %{"techstack" => tech_stack}}} when is_list(tech_stack) -> 
        {:ok, tech_stack}
      {:ok, _} -> 
        {:error, "No tech stack information available"}
      error -> error
    end
  end

  @doc """
  Searches for companies using specific technologies.

  ## Parameters
    - client: RocketReach client struct
    - technologies: List of technology names

  ## Returns
    - `{:ok, response}` containing matching companies
    - `{:error, reason}` on failure
  """
  def search_companies_by_tech(client, technologies) when is_list(technologies) do
    search_query = %{
      query: %{
        techstack: technologies
      }
    }
    search_companies(client, search_query)
  end

  def get_company_competitors(client, domain) do
    case lookup_company(client, %{domain: domain}) do
      {:ok, %{body: %{"competitors" => competitors}}} when is_list(competitors) ->
        {:ok, competitors}
      {:ok, _} ->
        {:error, "No competitor information available"}
      error -> error
    end
  end

  def get_company_industries(client, domain) do
    case lookup_company(client, %{domain: domain}) do
      {:ok, %{body: %{"industries" => industries}}} when is_list(industries) ->
        {:ok, industries}
      {:ok, _} ->
        {:error, "No industry information available"}
      error -> error
    end
  end

  def get_company_growth(client, domain) do
    case lookup_company(client, %{domain: domain}) do
      {:ok, %{body: %{"company_growth" => growth}}} when is_list(growth) ->
        {:ok, growth}
      {:ok, _} ->
        {:error, "No growth information available"}
      error -> error
    end
  end

  def search_companies_by_size(client, min_size, max_size) do
    search_query = %{
      query: %{
        company_size_min: ["#{min_size}"],
        company_size_max: ["#{max_size}"]
      }
    }
    search_companies(client, search_query)
  end

  def search_companies_by_revenue(client, min_revenue, max_revenue) do
    search_query = %{
      query: %{
        company_revenue_min: ["#{min_revenue}"],
        company_revenue_max: ["#{max_revenue}"]
      }
    }
    search_companies(client, search_query)
  end

  def get_company_funding(client, domain) do
    case lookup_company(client, %{domain: domain}) do
      {:ok, %{body: %{"funding_investors" => investors}}} when is_list(investors) ->
        {:ok, investors}
      {:ok, _} ->
        {:error, "No funding information available"}
      error -> error
    end
  end

  def search_companies_by_location(client, location, radius, unit \\ "mi") do
    search_query = %{
      query: %{
        location: ["\"#{location}\"::~#{radius}#{unit}"]
      }
    }
    search_companies(client, search_query)
  end

  def get_company_size(client, domain) do
    case lookup_company(client, %{domain: domain}) do
      {:ok, %{body: %{"num_employees" => count}}} when not is_nil(count) ->
        {:ok, count}
      {:ok, _} ->
        {:error, "No employee count information available"}
      error -> error
    end
  end

  def is_publicly_traded?(client, domain) do
    case lookup_company(client, %{domain: domain}) do
      {:ok, %{body: %{"ticker_symbol" => ticker}}} when not is_nil(ticker) ->
        {:ok, true}
      {:ok, _} ->
        {:ok, false}
      error -> error
    end
  end
 @doc """
  Get company organizational chart by domain
  """
  def get_org_chart(client, domain) do
    with {:ok, %{body: company}} <- lookup_company(client, %{domain: domain}),
         {:ok, %{body: %{"profiles" => employees}}} <- search_company_employees(client, domain) do
      {:ok, organize_employees(employees)}
    end
  end

  @doc """
  Search for all employees at a company with their roles and reporting structure
  """
  def search_company_employees(client, domain) do
    search_query = %{
      query: %{
        current_employer: [domain],
        management_levels: ["C-Level", "VP", "Director", "Manager", "Individual Contributor"]
      },
      page_size: 100
    }
    
    search_people(client, search_query)
  end

  @doc """
  Get employees by department
  """
  def get_department_structure(client, domain, department) do
    search_query = %{
      query: %{
        current_employer: [domain],
        department: [department]
      },
      page_size: 100
    }
    
    search_people(client, search_query)
  end

  @doc """
  Get direct reports for a specific person
  """
  def get_direct_reports(client, manager_id) do
    with {:ok, %{body: manager}} <- lookup_person(client, %{id: manager_id}),
         {:ok, %{body: %{"profiles" => employees}}} <- search_company_employees(client, manager["current_employer_domain"]) do
      potential_reports = filter_potential_direct_reports(employees, manager)
      {:ok, potential_reports}
    end
  end

  @doc """
  Get company leadership team
  """
  def get_leadership_team(client, domain) do
    search_query = %{
      query: %{
        current_employer: [domain],
        management_levels: ["C-Level", "VP"]
      }
    }
    
    search_people(client, search_query)
  end

  # Private helper functions

  defp organize_employees(employees) do
    employees
    |> Enum.group_by(&get_management_level/1)
    |> Map.new(fn {level, emps} -> 
      {level, Enum.group_by(emps, &(&1["department"]))}
    end)
  end

  defp get_management_level(employee) do
    cond do
      String.contains?(employee["current_title"], ["CEO", "CTO", "CFO", "COO", "Chief"]) -> "C-Level"
      String.contains?(employee["current_title"], "VP") -> "VP"
      String.contains?(employee["current_title"], "Director") -> "Director"
      String.contains?(employee["current_title"], "Manager") -> "Manager"
      true -> "Individual Contributor"
    end
  end

  defp filter_potential_direct_reports(employees, manager) do
    manager_level = get_management_level(manager)
    
    employees
    |> Enum.filter(fn employee ->
      employee["department"] == manager["department"] &&
      is_lower_level?(get_management_level(employee), manager_level)
    end)
  end

  defp is_lower_level?(employee_level, manager_level) do
    levels = ["C-Level", "VP", "Director", "Manager", "Individual Contributor"]
    
    Enum.find_index(levels, &(&1 == employee_level)) >
      Enum.find_index(levels, &(&1 == manager_level))
  end
end
