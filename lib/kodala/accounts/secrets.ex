defmodule Kodala.Accounts.Secrets do
  @moduledoc "Secrets adapter for AshHq authentication"
  use AshAuthentication.Secret

  def secret_for([:authentication, :tokens, :signing_secret], Kodala.Accounts.User, _) do
    Application.fetch_env(:kodala, :token_signing_secret)
  end
end
