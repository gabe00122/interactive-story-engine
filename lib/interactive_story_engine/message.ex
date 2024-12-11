defmodule InteractiveStoryEngine.Message do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias InteractiveStoryEngine.Repo
  alias Phoenix.PubSub
  alias __MODULE__

  schema "messages" do
    field :message, :string
    belongs_to :user, InteractiveStoryEngine.Accounts.User

    timestamps()
  end

  def changeset(message, attrs) do
    message
    |> cast(attrs, [:message])
    |> validate_required([:message])
    |> validate_length(:message, min: 2)
  end

  def create_message(attrs, user) do
    %Message{}
    |> changeset(attrs)
    |> put_assoc(:user, user)
    |> Repo.insert()
    |> notify(:message_created)
  end

  def list_messages do
    Message
    |> limit(20)
    |> order_by(desc: :inserted_at)
    |> preload(:user)
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
