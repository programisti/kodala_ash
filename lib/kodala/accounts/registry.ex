defmodule Kodala.Accounts.Registry do
  use Ash.Registry,
    extensions: Ash.Registry.ResourceValidations

  entries do
    entry Kodala.Accounts.User
    entry Kodala.Accounts.Token
  end
end
