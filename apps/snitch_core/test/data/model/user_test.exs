defmodule Snitch.Data.Model.UserTest do
  use ExUnit.Case, async: true
  use Snitch.DataCase


  alias Snitch.Data.Model.User

  describe "create/1" do
    setup do
      valid_attrs = %{
        first_name: "John",
        last_name: "Doe",
        email: "john@domain.com",
        password: "password123",
        password_confirmation: "password123"
      }
      [valid_attrs: valid_attrs]
    end

    test "FAILS for invalid attributes", %{valid_attrs: va} do
      params = Map.update!(va, :password_confirmation, fn _ -> "does not match" end)
      assert {:error, changeset} = User.create(params)
      IO.inspect changeset
      # refute changeset.valid?
      # assert %{password_confirmation: ["does not match confirmation"]} = errors_on(changeset)
    end
  end
end
