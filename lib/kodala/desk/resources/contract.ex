defmodule Kodala.Desk.Contract do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource, AshGraphql.Resource]

  attributes do
    uuid_primary_key :id
    attribute :name, :string
    attribute :color, :string
    attribute :rate, :integer
    attribute :session, :integer
    attribute :chat_missed, :integer
    attribute :chat_miss_time, :integer
    attribute :chat_miss_fee, :integer
    attribute :minutes_worked, :integer
    attribute :minutes_worked_today, :integer
    attribute :minutes_worked_this_week, :integer
    attribute :minutes_worked_last_week, :integer

    attribute :status, :atom do
      constraints [one_of: [:invited, :closed]]
      default :invited
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
    type :contract

    queries do
      get :get_contract, :read 
      list :list_contracts, :read 
    end

    mutations do
      create :create_contract, :create
      update :update_contract, :update
      destroy :destroy_contract, :destroy
    end
  end

  relationships do
    belongs_to :website, Kodala.Desk.Website do
      api Kodala.Desk
      allow_nil? false
    end

    belongs_to :agent, Kodala.Desk.Agent do
      api Kodala.Desk
      allow_nil? false
    end

    belongs_to :job, Kodala.Desk.Job
    belongs_to :company, Kodala.Desk.Company
    belongs_to :proposal, Kodala.Desk.Proposal
    has_many :chats, Kodala.Desk.Chat
  end

  postgres do
    table "contracts"
    repo Kodala.Repo
  end
end