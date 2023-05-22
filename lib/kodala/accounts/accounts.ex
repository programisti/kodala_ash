defmodule Kodala.Accounts do
  use Ash.Api,
    otp_app: :kodala,
    extensions: [AshAdmin.Api, AshGraphql.Api, AshJsonApi.Api]

  # authorization do
  #   authorize :by_default
  # end
  
  # graphql do
  #   authorize? true
  # end

  admin do
    show? true
  end

  resources do
    registry Kodala.Accounts.Registry
  end
end
