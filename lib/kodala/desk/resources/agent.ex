defmodule Kodala.Desk.Agent do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource, AshGraphql.Resource]

  attributes do
    uuid_primary_key :id
    attribute :name, :string
    attribute :rate, :integer
    attribute :picture, :string
    attribute :session, :integer
    attribute :country, :string
    attribute :cover, :string
    attribute :time_worked, :integer
    attribute :client_feedback, :integer
    attribute :missed_clients, :integer
  end
  
  code_interface do
    define_for Kodala.Desk
    define :read, action: :read
    define :update, action: :update
    define :destroy, action: :destroy
    define :create, action: :create
  end


  actions do
    defaults [:read, :update, :destroy]
    create :create do
      accept [:email]
      argument :email, :string
      argument :password, :string

      change fn changeset, _ ->
        IO.inspect(changeset)
        email = Ash.Changeset.get_argument(changeset, :email)
        password = Ash.Changeset.get_argument(changeset, :password)

        Kodala.Accounts.User
        |> Ash.Changeset.for_create(:create, %{email: email, password: password})
        |> Kodala.Accounts.create!()

        Kodala.Accounts.Agent
        |> Ash.Changeset.for_create(:create, changeset.attributes)
        |> Kodala.Desk.create!()

        # validate confirm(:password, :password_confirmation)
        # change Kodala.Accounts.User.Changes.HashPassword
      end

      change AshAuthentication.GenerateTokenChange
      upsert? true
      upsert_identity :unique_email
    end

  end

  graphql do
    type :agent

    mutations do
      create :signup_agent, :create
    end
  end

  relationships do
    belongs_to :user, Kodala.Accounts.User do
      api Kodala.Accounts
      allow_nil? false
    end
    
    has_many :proposals, Kodala.Desk.Proposal
    has_many :contracts, Kodala.Desk.Contract
  end
  

  postgres do
    table "agents"
    repo Kodala.Repo

    references do
      reference :user do
        on_delete :delete
      end
    end
  end
end