defmodule Despite.UserTest do
  use Despite.ModelCase

  alias Despite.User

  @valid_attrs %{gender: "some content", phone_number: "some content", username: "some content"}
  @invalid_attrs %{}

  # test "changeset with valid attributes" do
  #   changeset = User.changeset(%User{}, @valid_attrs)
  #   assert changeset.valid?
  # end
  #
  # test "changeset with invalid attributes" do
  #   changeset = User.changeset(%User{}, @invalid_attrs)
  #   refute changeset.valid?
  # end
end
