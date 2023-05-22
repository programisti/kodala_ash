defmodule Kodala.Desk.Registry do
  use Ash.Registry,
    extensions: [
      # This extension adds helpful compile time validations
      Ash.Registry.ResourceValidations
    ]


  entries do
    entry Kodala.Desk.Agent
    entry Kodala.Desk.Chat
    entry Kodala.Desk.Company
    entry Kodala.Desk.Contract
    entry Kodala.Desk.Job
    entry Kodala.Desk.Message
    entry Kodala.Desk.Proposal
    entry Kodala.Desk.Website
  end
end