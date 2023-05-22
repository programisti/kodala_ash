defmodule Kodala.Desk.Website do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource, AshGraphql.Resource]

  attributes do
    uuid_primary_key :id
    attribute :name, :string
    attribute :address, :string
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
    type :website

    queries do
      get :get_website, :read 
      list :list_websites, :read 
    end

    mutations do
      create :create_website, :create
      update :update_website, :update
      destroy :destroy_website, :destroy
    end
  end

  relationships do
    belongs_to :company, Kodala.Desk.Company do
      allow_nil? false
    end

    has_many :contracts, Kodala.Desk.Contract
  end

  postgres do
    table "websites"
    repo Kodala.Repo
  end
end