defmodule Kodala.Desk.Company do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource, AshGraphql.Resource]

  attributes do
    uuid_primary_key :id
    attribute :name, :string
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
    type :company

    queries do
      get :get_copmany, :read 
      list :list_companies, :read 
    end

    mutations do
      create :create_company, :create
      update :update_company, :update
      destroy :destroy_company, :destroy
    end
  end

  relationships do
    belongs_to :user, Kodala.Accounts.User do
      api Kodala.Accounts
      allow_nil? false
    end
    
    has_many :websites, Kodala.Desk.Website
    has_many :contracts, Kodala.Desk.Contract
  end

  postgres do
    table "companies"
    repo Kodala.Repo

    references do
      reference :user do
        on_delete :delete
      end
    end
  end
end