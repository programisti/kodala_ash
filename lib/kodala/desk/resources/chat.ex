defmodule Kodala.Desk.Chat do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource, AshGraphql.Resource]

  attributes do
    uuid_primary_key :id
    attribute :customer_name, :string
    attribute :headline, :string
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
    type :chat

    queries do
      get :get_chat, :read 
      list :list_chat, :read 
    end

    mutations do
      create :create_chat, :create
      update :update_chat, :update
      destroy :destroy_chat, :destroy
    end
  end

  relationships do
    belongs_to :contract, Kodala.Desk.Contract do
      api Kodala.Desk
      allow_nil? false
    end
    
    has_many :messages, Kodala.Desk.Message
  end

  postgres do
    table "chats"
    repo Kodala.Repo
  end
end