defmodule InteractiveStoryEngineWeb.ChatLive do
  use InteractiveStoryEngineWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>

      <%= for message <- @messages do %>
        <div>
          <%= message.text %>
        </div>
      <% end %>

      <.form for={@form} phx-submit="save">
        <.input type="text" field={@form[:text]}/>

        <button>Send</button>
      </.form>
    </div>
    """
  end

  def mount(params, _session, socket) do

    if connected?(socket) do
      InteractiveStoryEngineWeb.Endpoint.subscribe("room")

    end

    socket = socket |> assign(
      messages: []
    )

    {:ok, socket |> assign(
      form: to_form(params),
      y: 0.0
    )}
  end

  def handle_event("save", params, socket) do
    IO.inspect(params)

    text = params["text"]
    message = %{text: text}

    InteractiveStoryEngineWeb.Endpoint.broadcast("room", "message_sent", message)

    {:noreply, socket}
  end

  def handle_info(%{event: "message_sent", payload: message}, socket) do
    socket = socket |> update(:messages, &(&1 ++ [message]))

    {:noreply, socket}
  end
end
