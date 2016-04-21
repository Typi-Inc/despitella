defmodule Despite.VerificationView do
  use Despite.Web, :view

  def render("index.json", %{verifications: verifications}) do
    %{data: render_many(verifications, Despite.VerificationView, "verification.json")}
  end

  def render("show.json", %{verification: verification}) do
    %{data: render_one(verification, Despite.VerificationView, "verification.json")}
  end

  def render("verification.json", %{verification: verification}) do
    %{phone_number: verification.phone_number}
  end
end
