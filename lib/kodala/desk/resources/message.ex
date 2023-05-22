defmodule Kodala.Desk.Message do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource, AshGraphql.Resource]

  attributes do
    uuid_primary_key :id
    attribute :text, :string
    attribute :author, :string
    attribute :is_agent, :boolean
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
    type :message

    queries do
      get :get_message, :read 
      list :list_messages, :read 
    end

    mutations do
      create :create_message, :create
      update :update_message, :update
      destroy :destroy_message, :destroy
    end
  end

  relationships do
    belongs_to :chat, Kodala.Desk.Chat do
      api Kodala.Desk
      allow_nil? false
    end
  end

  postgres do
    table "messages"
    repo Kodala.Repo
  end
end