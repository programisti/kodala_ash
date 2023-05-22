defmodule Kodala.Accounts.User do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication, AshAdmin.Resource]

  admin do
    actor? true
  end

  authentication do
    api Kodala.Accounts

    strategies do
      password :password do
        identity_field :email
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
    read :read do
      primary? true
      pagination offset?: true
    end
  end

  identities do
    identity :unique_email, [:email]
  end

  postgres do
    table "users"
    repo Kodala.Repo
  end

  attributes do
    uuid_primary_key :id

    attribute :email, :ci_string do
      allow_nil? false
    end

    attribute :hashed_password, :string do
      sensitive? true
    end

    timestamps()
  end

end
