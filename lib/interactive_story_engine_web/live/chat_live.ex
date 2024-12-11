defmodule InteractiveStoryEngineWeb.ChatLive do
  use InteractiveStoryEngineWeb, :live_view
  alias InteractiveStoryEngine.Message

  def render(assigns) do
    ~H"""
    <div>
      <%= for message <- @messages do %>
        <div>
          <b>{ message.user.email }:</b>
          { message.message }
        </div>
      <% end %>

      <.form id="msg-form" for={@form} phx-submit="new_message">
        <.input id="msg" label="Message" type="text" field={@form[:message]} />

        <div class="py-2">
          <.button>Send</.button>
        </div>
      </.form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Message.subscribe()
    end

    messages = Message.list_messages() |> Enum.reverse()

    {:ok,
     socket
     |> assign(
       messages: messages,
       form: to_form(%{})
     )}
  end

  def handle_event("new_message", message, socket) do
    case Message.create_message(message, socket.assigns.current_user) do
      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
      :ok ->
        socket = socket |> push_event("message-sent", %{})
        {:noreply, assign(socket, form: to_form(%{"message" => ""}))}
    end
  end

  def handle_info({:message_created, message}, socket) do
    socket = socket |> update(:messages, &(&1 ++ [message]))

    {:noreply, socket}
  end
end
