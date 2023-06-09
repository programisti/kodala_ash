defmodule Kodala.Repo.Migrations.MigrateResources2 do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    rename table(:websites), :copmany_id, to: :company_id
  end

  def down do
    rename table(:websites), :company_id, to: :copmany_id
  end
end