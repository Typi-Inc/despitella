defmodule Despite.MessageView do
  use Despite.Web, :view

  def render("message.json", %{message: message}) do
    %{
      id: message.id,
      body: message.body,
      inserted_at: message.inserted_at,
      sender: render_one(message.sender, Despite.UserView, "user.json")
    }
  end
end
