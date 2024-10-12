defmodule InteractiveStoryEngine.Repo do
  use Ecto.Repo,
    otp_app: :interactive_story_engine,
    adapter: Ecto.Adapters.Postgres
end
