defmodule Despite.VerificationTest do
  use Despite.ModelCase

  alias Despite.Verification

  @valid_attrs %{code: "12345", phone_number: "+12342342323"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Verification.changeset(%Verification{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Verification.changeset(%Verification{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with valid attributes hashes code" do
    changeset = Verification.changeset(%Verification{}, @valid_attrs)
    %{code: code, code_hash: code_hash} = changeset.changes

    assert changeset.valid?
    assert code_hash
    assert Comeonin.Bcrypt.checkpw(code, code_hash)
  end
end
