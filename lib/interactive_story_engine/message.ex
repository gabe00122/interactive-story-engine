defmodule InteractiveStoryEngine.Message do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias InteractiveStoryEngine.Repo
  alias Phoenix.PubSub
  alias __MODULE__

  schema "messages" do
    field :message, :string
    field :name, :string

    timestamps()
  end

  def changeset(message, attrs) do
    message
    |> cast(attrs, [:name, :message])
    |> validate_required([:name, :message])
    |> validate_length(:message, min: 2)
  end

  def create_message(attrs) do
    %Message{}
    |> changeset(attrs)
    |> Repo.insert()
    |> notify(:message_created)
  end

  def list_messages do
    Message
    |> limit(20)
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def subscribe() do
    PubSub.subscribe(InteractiveStoryEngine.PubSub, "chat")
  end

  def notify({:ok, message}, event) do
    PubSub.broadcast(InteractiveStoryEngine.PubSub, "chat", {event, message})
  end

  def notify({:error, reason}, _event), do: {:error, reason}
end