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
    define :create, action: :create
    define :read, action: :read
    define :update, action: :update
    define :destroy, action: :destroy
  end


  actions do
    defaults [:create, :read, :update, :destroy]
  end

  # graphql do
  #   type :agent

  #   queries do
  #     get :get_job, :read 
  #     list :list_jobs, :read 
  #   end

  #   mutations do
  #     create :create_job, :create
  #     update :update_job, :update
  #     destroy :destroy_job, :destroy
  #   end
  # end

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