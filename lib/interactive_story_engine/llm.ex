defmodule InteractiveStoryEngine.Llm do
  def completion(messages) do
    response =
      Req.post!(
        "http://192.168.0.149:3999/v1/chat/completions",
        # connect_options: %{timeout: 100_000},
        receive_timeout: 120_000,
        json: %{messages: messages}
      )

    response.body["choices"] |> List.first() |> Map.fetch!("message")
  end

  def user_message(prompt) do
    %{role: :user, content: prompt}
  end

  def poc(messages) do
    prompt = IO.gets("Prompt: ")
    # prompt = "The player chooses: '" + prompt + "' is this plasible for this setting?"

    messages = messages ++ [user_message(prompt)]

    message = completion(messages)
    IO.puts(message["content"])
    messages = messages ++ [message]

    poc(messages)
  end
end
