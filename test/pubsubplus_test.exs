defmodule PubSubPlusTest do
  use ExUnit.Case

  def count_mailbox_messages do
    # HACK: yield process for a bit just
    # so it can populate its mailbox
    Process.sleep(10)

    {:messages, messages} = Process.info(self, :messages)
    messages |> length
  end

  setup_all do
    {:ok, _} = PubSubPlus.start_link()
    {:ok, %{}}
  end

  setup do
    on_exit fn ->
      PubSubPlus.unsubscribe(self, "car")
      PubSubPlus.unsubscribe(self, "plane.fly.speed")
    end
  end

  test "should be able to subscribe" do
    assert {:ok, _} = PubSubPlus.subscribe(self, "car")
  end

  test "should be able to subscribe to nested topics" do
    assert {:ok, _} = PubSubPlus.subscribe(self, "plane.fly.speed")
  end

  test "should be able to publish" do
    assert {:ok, _} = PubSubPlus.subscribe(self, "car")
    assert {:ok, _} = PubSubPlus.publish("car", {:message, "hello!"})
    assert_receive {:message, _}

    assert {:ok, _} = PubSubPlus.subscribe(self, "plane.fly.speed")
    assert {:ok, _} = PubSubPlus.publish("plane.fly", {:message, "hello!"})
    assert count_mailbox_messages() == 2
  end

  test "should be able to fetch subscribers" do
    assert {:ok, _} = PubSubPlus.subscribe(self, "car")
    assert %{"car" => _} = PubSubPlus.subscribers("car")

    assert {:ok, _} = PubSubPlus.subscribe(self, "plane.fly.speed")
    assert %{
      "plane" => plane_pids,
      "plane.fly" => fly_pids,
      "plane.fly.speed" => speed_pids
    } = PubSubPlus.subscribers("plane.fly.speed")
    assert length(plane_pids) == 1
    assert length(fly_pids) == 1
    assert length(speed_pids) == 1
  end

  test "should be able to unsubscribe" do
    assert {:ok, _} = PubSubPlus.unsubscribe(self, "plane.fly.speed")
  end

  test "should be able to return topics" do
    assert {:ok, _} = PubSubPlus.subscribe(self, "plane.fly.speed")
    topics = PubSubPlus.topics()

    expected_topics = [:plane, :"plane.fly", :"plane.fly.speed"]
    assert expected_topics |> Enum.all?(&Enum.member?(topics, &1))
  end
end

