defmodule Kodala.Desk do
  use Ash.Api, extensions: [
    AshJsonApi.Api,
    AshGraphql.Api,
    AshAdmin.Api
  ]
  
  admin do
    show? true
  end
  
  graphql do
    authorize? false # Defaults to `true`, use this to disable authorization for the entire API (you probably only want this while prototyping)
    root_level_errors? true
  end

  resources do
    # This defines the set of resources that can be used with this API
    registry Kodala.Desk.Registry
  end
end