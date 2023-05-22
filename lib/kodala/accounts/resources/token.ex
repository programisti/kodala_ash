defmodule Kodala.Accounts.Token do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication.TokenResource]

  actions do
    defaults [:destroy]
  end

  code_interface do
    define_for Kodala.Accounts
    define :destroy
  end

  token do
    api Kodala.Accounts
  end

  postgres do
    table "tokens"
    repo Kodala.Repo
  end

  attributes do
    uuid_primary_key :id

    timestamps()
  end
end
