defmodule InteractiveStoryEngine.Repo.Migrations.RemoveMessageName do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      remove :name
    end
  end
end
