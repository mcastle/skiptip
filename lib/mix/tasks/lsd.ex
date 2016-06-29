defmodule Mix.Tasks.SkipTip.LoadSampleData do
  use Mix.Task
  alias Skiptip.Factory
  alias Skiptip.Utils
  alias Skiptip.Repo

  @shortdoc "Loads sample data to development db"

  def run(_args) do
    Mix.Task.run "app.start", []
    Repo.delete_all(Skiptip.User)
    Repo.delete_all(Skiptip.BuyerProfile)
    Repo.delete_all(Skiptip.Message)
    Repo.delete_all(Skiptip.FacebookLogin)
    create_users
  end

  def create_users do
    real_fb_token = "EAAHKZAy11I6YBAL30zvBLLtT3X2CZCjv7ZAxgzrykycd9vuPPHFrqxGTM7DfdB0w5wILJrfuyzqjUdptNPUW0utnNsc4OGmbjaR3QdOiUWMStNk20UZCWLBsFTuiI4P6wMTCfsm0Qn6S588RNxXcECMerLmUVtJneuOMSZAF9R7K8ksMmFC9J5QsqRijlZAgBzJOYQuzuC6AZDZD"
    real_fb_uid = "10154127153411215"
    brian = Factory.create_user(real_fb_token, real_fb_uid, %{name: "Brian Maxwell", email: "brianmaxwell1@gmail.com"})
    max = Factory.create_user(%{name: "Max Rockatansky", email: "max@something.com"})
    lester = Factory.create_user(%{name: "Lester Burnham", email: "Lester@something.com"})
    travis = Factory.create_user(%{name: "Travis Bickle", email: "Travis@something.com"})
    dave = Factory.create_user(%{name: "Dave Bowman", email: "Dave@something.com"})
    sean = Factory.create_user(%{name: "Sean Maguire", email: "Sean@something.com"})
    Factory.send_message(brian, max, "test message")
    Factory.send_message(brian, max, "test message 2")
    Factory.send_message(max, brian, "test message 3")
  end
end
