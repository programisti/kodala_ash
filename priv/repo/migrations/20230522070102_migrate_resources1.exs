defmodule Kodala.Repo.Migrations.MigrateResources1 do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:websites, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("uuid_generate_v4()"), primary_key: true
      add :name, :text
      add :address, :text
      add :copmany_id, :uuid, null: false
    end

    create table(:proposals, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("uuid_generate_v4()"), primary_key: true
      add :cover, :text
      add :rate, :bigint
      add :job_id, :uuid, null: false
      add :agent_id, :uuid, null: false
    end

    create table(:messages, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("uuid_generate_v4()"), primary_key: true
      add :text, :text
      add :author, :text
      add :is_agent, :boolean
      add :chat_id, :uuid, null: false
    end

    create table(:jobs, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("uuid_generate_v4()"), primary_key: true
    end

    alter table(:proposals) do
      modify :job_id,
             references(:jobs,
               column: :id,
               name: "proposals_job_id_fkey",
               type: :uuid,
               prefix: "public",
               on_delete: :delete_all
             )
    end

    alter table(:jobs) do
      add :name, :text
      add :rate, :bigint
      add :picture, :text
      add :session, :bigint
      add :country, :text
      add :cover, :text
      add :time_worked, :bigint
      add :client_feedback, :bigint
      add :missed_clients, :bigint
      add :status, :text, null: false, default: "active"
      add :company_id, :uuid, null: false
      add :website_id, :uuid, null: false
    end

    create table(:contracts, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("uuid_generate_v4()"), primary_key: true
      add :name, :text
      add :color, :text
      add :rate, :bigint
      add :session, :bigint
      add :chat_missed, :bigint
      add :chat_miss_time, :bigint
      add :chat_miss_fee, :bigint
      add :minutes_worked, :bigint
      add :minutes_worked_today, :bigint
      add :minutes_worked_this_week, :bigint
      add :minutes_worked_last_week, :bigint
      add :status, :text, null: false, default: "invited"

      add :website_id,
          references(:websites,
            column: :id,
            name: "contracts_website_id_fkey",
            type: :uuid,
            prefix: "public"
          ),
          null: false

      add :agent_id, :uuid, null: false
      add :job_id, :uuid
      add :company_id, :uuid
      add :proposal_id, :uuid
    end

    create table(:companies, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("uuid_generate_v4()"), primary_key: true
    end

    alter table(:websites) do
      modify :copmany_id,
             references(:companies,
               column: :id,
               name: "websites_copmany_id_fkey",
               type: :uuid,
               prefix: "public"
             )
    end

    alter table(:jobs) do
      modify :company_id,
             references(:companies,
               column: :id,
               name: "jobs_company_id_fkey",
               type: :uuid,
               prefix: "public"
             )

      modify :website_id,
             references(:companies,
               column: :id,
               name: "jobs_website_id_fkey",
               type: :uuid,
               prefix: "public"
             )
    end

    alter table(:companies) do
      add :name, :text

      add :user_id,
          references(:users,
            column: :id,
            name: "companies_user_id_fkey",
            type: :uuid,
            prefix: "public",
            on_delete: :delete_all
          ),
          null: false
    end

    create table(:chats, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("uuid_generate_v4()"), primary_key: true
    end

    alter table(:messages) do
      modify :chat_id,
             references(:chats,
               column: :id,
               name: "messages_chat_id_fkey",
               type: :uuid,
               prefix: "public"
             )
    end

    alter table(:chats) do
      add :customer_name, :text
      add :headline, :text
      add :status, :text, null: false, default: "active"

      add :contract_id,
          references(:contracts,
            column: :id,
            name: "chats_contract_id_fkey",
            type: :uuid,
            prefix: "public"
          ),
          null: false
    end

    create table(:agents, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("uuid_generate_v4()"), primary_key: true
    end

    alter table(:proposals) do
      modify :agent_id,
             references(:agents,
               column: :id,
               name: "proposals_agent_id_fkey",
               type: :uuid,
               prefix: "public"
             )
    end

    alter table(:contracts) do
      modify :agent_id,
             references(:agents,
               column: :id,
               name: "contracts_agent_id_fkey",
               type: :uuid,
               prefix: "public"
             )

      modify :job_id,
             references(:jobs,
               column: :id,
               name: "contracts_job_id_fkey",
               type: :uuid,
               prefix: "public"
             )

      modify :company_id,
             references(:companies,
               column: :id,
               name: "contracts_company_id_fkey",
               type: :uuid,
               prefix: "public"
             )

      modify :proposal_id,
             references(:proposals,
               column: :id,
               name: "contracts_proposal_id_fkey",
               type: :uuid,
               prefix: "public"
             )
    end

    alter table(:agents) do
      add :name, :text
      add :rate, :bigint
      add :picture, :text
      add :session, :bigint
      add :country, :text
      add :cover, :text
      add :time_worked, :bigint
      add :client_feedback, :bigint
      add :missed_clients, :bigint

      add :user_id,
          references(:users,
            column: :id,
            name: "agents_user_id_fkey",
            type: :uuid,
            prefix: "public",
            on_delete: :delete_all
          ),
          null: false
    end
  end

  def down do
    drop constraint(:agents, "agents_user_id_fkey")

    alter table(:agents) do
      remove :user_id
      remove :missed_clients
      remove :client_feedback
      remove :time_worked
      remove :cover
      remove :country
      remove :session
      remove :picture
      remove :rate
      remove :name
    end

    drop constraint(:contracts, "contracts_agent_id_fkey")

    drop constraint(:contracts, "contracts_job_id_fkey")

    drop constraint(:contracts, "contracts_company_id_fkey")

    drop constraint(:contracts, "contracts_proposal_id_fkey")

    alter table(:contracts) do
      modify :proposal_id, :uuid
      modify :company_id, :uuid
      modify :job_id, :uuid
      modify :agent_id, :uuid
    end

    drop constraint(:proposals, "proposals_agent_id_fkey")

    alter table(:proposals) do
      modify :agent_id, :uuid
    end

    drop table(:agents)

    drop constraint(:chats, "chats_contract_id_fkey")

    alter table(:chats) do
      remove :contract_id
      remove :status
      remove :headline
      remove :customer_name
    end

    drop constraint(:messages, "messages_chat_id_fkey")

    alter table(:messages) do
      modify :chat_id, :uuid
    end

    drop table(:chats)

    drop constraint(:companies, "companies_user_id_fkey")

    alter table(:companies) do
      remove :user_id
      remove :name
    end

    drop constraint(:jobs, "jobs_company_id_fkey")

    drop constraint(:jobs, "jobs_website_id_fkey")

    alter table(:jobs) do
      modify :website_id, :uuid
      modify :company_id, :uuid
    end

    drop constraint(:websites, "websites_copmany_id_fkey")

    alter table(:websites) do
      modify :copmany_id, :uuid
    end

    drop table(:companies)

    drop constraint(:contracts, "contracts_website_id_fkey")

    drop table(:contracts)

    alter table(:jobs) do
      remove :website_id
      remove :company_id
      remove :status
      remove :missed_clients
      remove :client_feedback
      remove :time_worked
      remove :cover
      remove :country
      remove :session
      remove :picture
      remove :rate
      remove :name
    end

    drop constraint(:proposals, "proposals_job_id_fkey")

    alter table(:proposals) do
      modify :job_id, :uuid
    end

    drop table(:jobs)

    drop table(:messages)

    drop table(:proposals)

    drop table(:websites)
  end
end