defmodule PubSubPlus do

  ###
  # APIs
  ###

  def start_link do
    {:ok, _} = PubSub.start_link()
  end

  def subscribe(subscriber_pid, topic) do
    execute(topic, &(PubSub.subscribe(subscriber_pid, &1)))
    |> case do
         true -> {:ok, nil}
            _ -> {:error, "Error subscribing"}
       end
  end

  def unsubscribe(subscriber_pid, topic) do
    execute(topic, &(PubSub.unsubscribe(subscriber_pid, &1)))
    |> case do
         true -> {:ok, nil}
            _ -> {:error, "Error unsubscribing"}
       end
  end

  def publish(topic, message) do
    execute(topic, &(PubSub.publish(&1, message)))
    |> case do
         true -> {:ok, nil}
            _ -> {:error, "Error publishing"}
       end
  end

  def subscribers(topic) do
    run(topic, &({&1, &1 |> PubSub.subscribers}))
    |> Enum.reduce(%{}, fn({subtopic, pids}, acc) ->
         acc |> Map.put(subtopic |> Atom.to_string, pids)
       end)
  end

  def topics, do: PubSub.topics()

  ###
  # Helpers
  ###

  defp run(topic, fun) do
    topic
    |> parse_subtopics
    |> Enum.map(&(fun.(&1)))
  end

  defp execute(topic, fun) do
    run(topic, fun)
    |> Enum.all?(&(&1 == :ok))
  end

  defp parse_subtopics(topic) do
    topic
    |> String.trim
    |> String.split(".")
    |> Enum.reduce([], &([&2 |> build_topic(&1) | &2]))
    |> Enum.map(&String.to_atom/1)
    |> Enum.reverse
  end

  defp build_topic(topics, topic) do
    case topics do
      [] -> topic
      [head|_] -> "#{head}.#{topic}"
    end
  end

end
