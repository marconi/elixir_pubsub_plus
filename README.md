# PubSubPlus

Just another pubsub + nested topic support.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `pubsub_plus` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:pubsub_plus, "~> 0.0.1"}]
    end
    ```

  2. Ensure `pubsub_plus` is started before your application:

    ```elixir
    def application do
      [applications: [:pubsub_plus]]
    end
    ```

## Usage

```elixir
iex(1)> {:ok, _} = PubSubPlus.start_link()
{:ok, #PID<0.188.0>}
iex(2)> PubSubPlus.subscribe(self, "do.something.stupid")
{:ok, nil}
iex(3)> PubSubPlus.publish("do.something", {:message, "Take a walk"})
{:ok, nil}
iex(4)> flush()
{:message, "Take a walk"} # <- do
{:message, "Take a walk"} # <- do.something
:ok
```

