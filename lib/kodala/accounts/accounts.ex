defmodule Kodala.Accounts do
  use Ash.Api, extensions: [AshAdmin.Api]

  admin do
    show? true
  end

  resources do
    registry Kodala.Accounts.Registry
  end
end
