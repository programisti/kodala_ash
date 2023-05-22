defmodule Kodala.Accounts.User do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication, AshAdmin.Resource],
    authorizers: [
      Ash.Policy.Authorizer
    ]

  admin do
    actor? true
  end

  authentication do
    api Kodala.Accounts

    strategies do
      password :password do
        identity_field :email
        hashed_password_field :hashed_password
        sign_in_tokens_enabled? true
        confirmation_required? false

      end
    end

    tokens do
      enabled? true
      require_token_presence_for_authentication? true
      signing_secret Kodala.Accounts.Secrets
      store_all_tokens? true
      token_resource Kodala.Accounts.Token
    end
  end

  code_interface do
    define_for Kodala.Accounts
  end

  actions do
    defaults [:create]
    read :read do
      primary? true
      pagination offset?: true
    end
  end

  identities do
    identity :unique_email, [:email]
  end

  attributes do
    uuid_primary_key :id

    attribute :hashed_password, :string, private?: true, sensitive?: true
    attribute :password, :string
    attribute :email, :ci_string do
      allow_nil? false
    end
    timestamps()
  end

  postgres do
    table "users"
    repo Kodala.Repo
  end
end
