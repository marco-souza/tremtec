defmodule Tremtec.Validators.Email do
  import Ecto.Changeset

  @pattern ~r/^[^@,;\s]+@[^@,;\s]+$/
  @max_length 160

  def pattern, do: @pattern

  def max_length, do: @max_length

  def validate_format(changeset, opts \\ []) do
    field = Keyword.get(opts, :field, :email)

    validation_opts =
      if Keyword.has_key?(opts, :message) do
        [message: Keyword.get(opts, :message)]
      else
        []
      end

    validate_format(changeset, field, @pattern, validation_opts)
  end

  def validate_length(changeset, opts \\ []) do
    field = Keyword.get(opts, :field, :email)
    max = Keyword.get(opts, :max, @max_length)

    validate_length(changeset, field, max: max)
  end

  def validate_all(changeset, opts \\ []) do
    changeset
    |> validate_format(opts)
    |> validate_length(opts)
  end
end
