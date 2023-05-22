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
    define :create, action: :create, args: [:email, :password]
    define :read, action: :read
    define :update, action: :update
    define :destroy, action: :destroy
  end


  actions do
    defaults [:read, :update, :destroy]
    create :signup_agent do
      argument :password, :string, allow_nil?: false
      run fn input, context ->
        IO.inspect(input)
        IO.inspect(context, label: "contexta")
        {:ok, ["123"]}
      end

    end
    # create :create do
    #   # By default all public attributes are accepted, but this should only take email
    #   accept [:email, :password]
    
    #   # Accept additional input by adding arguments
    #   argument :password, :string do
    #     allow_nil? false
    #   end
    
    #   argument :password_confirmation, :string do
    #     allow_nil? false
    #   end
    
    #   # Use the built in `confirm/2` validation
    #   validate confirm(:password, :password_confirmation)
    
    #   # Call a custom change that will hash the password
    #   change Kodala.Accounts.User.Changes.HashPassword
    # end
  end

  graphql do
    type :agent

    mutations do
      create :signup_agent, :signup_agent
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