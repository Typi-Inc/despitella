defmodule Despite.UserControllerTest do
  use Despite.ConnCase, async: true

  alias Despite.User
  alias Despite.Verification
  @valid_attrs %{"phone_number": "+12423423123"}
  @invalid_attrs %{"phone_number": "+12rfs"}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates verification when phone number is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :verify_phone_number), user: @valid_attrs
    assert json_response(conn, 201)["data"]["phone_number"]
    assert Repo.get_by(Verification, @valid_attrs)
  end

  test "does not create verification when phone_number is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :verify_phone_number), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
    refute Repo.get_by(Verification, @valid_attrs)
  end

  test "verification code is updated when send_code is invoked twice", %{conn: conn} do
    conn = post conn, user_path(conn, :verify_phone_number), user: @valid_attrs
    conn = post conn, user_path(conn, :verify_phone_number), user: @valid_attrs
    assert json_response(conn, 200)["data"]["phone_number"]
    assert Repo.get_by(Verification, @valid_attrs)
  end

  test "creates and renders user when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :verify_phone_number), user: @valid_attrs
    conn = post conn, user_path(conn, :create), user: Map.put(@valid_attrs, "code", "12345")
    %{"user" => user, "existing_user" => existing_user, "jwt" => jwt} = json_response(conn, 201)
    assert user["id"]
    refute existing_user
    assert jwt
    assert Repo.get_by(User, @valid_attrs)
  end

  test "does not create user if phone_number is not verified" do
    invalid_attrs = %{"phone_number": "+1231231123", "code": "12345"}
    conn = post conn, user_path(conn, :create), user: invalid_attrs
    assert json_response(conn, 401)["reason"]
    refute Repo.get_by(User, %{"phone_number": invalid_attrs.phone_number})
  end

  test "does not create user if verification code is not correct" do
    conn = post conn, user_path(conn, :verify_phone_number), user: @valid_attrs
    conn = post conn, user_path(conn, :create), user: Map.put(@valid_attrs, "code", "54321")
    assert json_response(conn, 401)["reason"]
    refute Repo.get_by(User, @valid_attrs)
  end

  test "if user already exists and data is valid sends existing_user: true" do
    conn = post conn, user_path(conn, :verify_phone_number), user: @valid_attrs
    conn = post conn, user_path(conn, :create), user: Map.put(@valid_attrs, "code", "12345")
    conn = post conn, user_path(conn, :verify_phone_number), user: @valid_attrs
    conn = post conn, user_path(conn, :create), user: Map.put(@valid_attrs, "code", "12345")
    %{"user" => user, "existing_user" => existing_user, "jwt" => jwt} = json_response(conn, 200)
    assert user["id"]
    assert existing_user
    assert jwt
    assert Repo.get_by(User, @valid_attrs)
  end

  # test "lists all entries on index", %{conn: conn} do
  #   conn = get conn, user_path(conn, :index)
  #   assert json_response(conn, 200)["data"] == []
  # end
  #
  # test "shows chosen resource", %{conn: conn} do
  #   user = Repo.insert! %User{}
  #   conn = get conn, user_path(conn, :show, user)
  #   assert json_response(conn, 200)["data"] == %{"id" => user.id,
  #     "phone_number" => user.phone_number,
  #     "gender" => user.gender,
  #     "username" => user.username}
  # end
  #
  # test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
  #   assert_error_sent 404, fn ->
  #     get conn, user_path(conn, :show, -1)
  #   end
  # end
  #
  # test "creates and renders resource when data is valid", %{conn: conn} do
  #   conn = post conn, user_path(conn, :create), user: @valid_attrs
  #   assert json_response(conn, 201)["data"]["id"]
  #   assert Repo.get_by(User, @valid_attrs)
  # end
  #
  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, user_path(conn, :create), user: @invalid_attrs
  #   assert json_response(conn, 422)["errors"] != %{}
  # end
  #
  # test "updates and renders chosen resource when data is valid", %{conn: conn} do
  #   user = Repo.insert! %User{}
  #   conn = put conn, user_path(conn, :update, user), user: @valid_attrs
  #   assert json_response(conn, 200)["data"]["id"]
  #   assert Repo.get_by(User, @valid_attrs)
  # end
  #
  # test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
  #   user = Repo.insert! %User{}
  #   conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
  #   assert json_response(conn, 422)["errors"] != %{}
  # end
  #
  # test "deletes chosen resource", %{conn: conn} do
  #   user = Repo.insert! %User{}
  #   conn = delete conn, user_path(conn, :delete, user)
  #   assert response(conn, 204)
  #   refute Repo.get(User, user.id)
  # end
end
