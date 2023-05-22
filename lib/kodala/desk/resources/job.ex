defmodule Kodala.Desk.Job do
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

    attribute :status, :atom do
      constraints [one_of: [:active, :closed]]
      default :active
      allow_nil? false
    end
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

  graphql do
    type :job

    queries do
      get :get_job, :read 
      list :list_jobs, :read 
    end

    mutations do
      create :create_job, :create
      update :update_job, :update
      destroy :destroy_job, :destroy
    end
  end

  relationships do
    belongs_to :company, Kodala.Desk.Company do
      api Kodala.Desk
      allow_nil? false
    end

    belongs_to :website, Kodala.Desk.Company do
      api Kodala.Desk
      allow_nil? false
    end
    
    has_many :proposals, Kodala.Desk.Proposal
  end

  postgres do
    table "jobs"
    repo Kodala.Repo
  end
end