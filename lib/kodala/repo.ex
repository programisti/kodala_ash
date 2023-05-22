defmodule Kodala.Repo do
  use AshPostgres.Repo, otp_app: :kodala

  # Installs Postgres extensions that ash commonly uses
  def installed_extensions do
    ["uuid-ossp", "citext"]
  end
end
