defmodule Despite.UserView do
  use Despite.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, Despite.UserView, "user.json")}
  end

  def render("show.json", %{user: user, jwt: jwt, existing_user: existing_user}) do
    %{
      jwt: jwt,
      user: render_one(user, Despite.UserView, "user.json"),
      existing_user: existing_user
    }
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      phone_number: user.phone_number,
      gender: user.gender,
      username: user.username}
  end
end
