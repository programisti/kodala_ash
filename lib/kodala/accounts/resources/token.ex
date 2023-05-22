defmodule Kodala.Accounts.Token do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [AshAuthentication.TokenResource]

  actions do
    defaults [:read, :destroy]

    read :email_token_for_user do
      get? true

      argument :user_id, :uuid do
        allow_nil? false
      end

      prepare build(sort: [updated_at: :desc], limit: 1)

      filter expr(purpose == "confirm" and not is_nil(extra_data[:email]))
    end
  end


  code_interface do
    define_for Kodala.Accounts
    define :destroy
    define :email_token_for_user, args: [:user_id]
  end

  token do
    api Kodala.Accounts
  end

  postgres do
    table "tokens"
    repo Kodala.Repo
  end

  relationships do
    belongs_to :user, Kodala.Accounts.User
  end
  
  policies do
    bypass AshAuthentication.Checks.AshAuthenticationInteraction do
      authorize_if always()
    end

    policy always() do
      description """
      There are currently no usages of user tokens resource that should be publicly
      accessible, they should all be using authorize?: false.
      """

      forbid_if always()
    end
  end

  attributes do
    uuid_primary_key :id

    timestamps()
  end
end
