defmodule Despite.Randomizer do
  def generate_random_code() do
    :random.seed(:os.timestamp)
    to_string(round(:random.uniform * 90000) + 10000)
  end
end
