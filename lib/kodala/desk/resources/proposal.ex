defmodule Kodala.Desk.Proposal do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource, AshGraphql.Resource]

  attributes do
    uuid_primary_key :id
    attribute :cover, :string
    attribute :rate, :integer
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
  #   type :proposal

  #   queries do
  #     get :get_eprob, :read 
  #     list :list_jobs, :read 
  #   end

  #   mutations do
  #     create :create_job, :create
  #     update :update_job, :update
  #     destroy :destroy_job, :destroy
  #   end
  # end

  relationships do
    belongs_to :job, Kodala.Desk.Job do
      api Kodala.Desk
      allow_nil? false
    end

    belongs_to :agent, Kodala.Desk.Agent do
      api Kodala.Desk
      allow_nil? false
    end
  end

  postgres do
    table "proposals"
    repo Kodala.Repo

    references do
      reference :job do
        on_delete :delete
      end
    end
  end
end