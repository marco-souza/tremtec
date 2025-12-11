defmodule Tremtec.Validators.Email do
  @moduledoc """
  Email validation utilities.

  Provides shared email validation logic for consistent validation across the app.

  ## Validation Pattern

  Uses the pattern: `~r/^[^@,;\s]+@[^@,;\s]+$/`

  This pattern:
  - Requires @ sign
  - Rejects emails with spaces, commas, or semicolons
  - Does not require TLD (accepts internal emails like `user@localhost`)
  - Does not support user+tag format (e.g., `user+tag@example.com`)

  The limitation with user+tag format is documented and acceptable per
  the project's MVP requirements (see contact_live.ex comments).
  """

  import Ecto.Changeset

  @pattern ~r/^[^@,;\s]+@[^@,;\s]+$/
  @max_length 160

  @doc """
  Email regex pattern used for format validation.

  Returns the compiled regex pattern for email validation.
  """
  def pattern, do: @pattern

  @doc """
  Maximum allowed email length (160 characters).
  """
  def max_length, do: @max_length

  @doc """
  Validates email format.

  Adds a format validation to the changeset for the email field.
  Uses the shared email pattern that rejects spaces and requires @ sign.

  ## Options

    * `:field` - The field to validate (default: `:email`)
    * `:message` - Custom error message (default: Ecto's "has invalid format")

  ## Examples

      changeset
      |> Email.validate_format()

      changeset
      |> Email.validate_format(field: :contact_email)
      |> Email.validate_format(message: "must have the @ sign and no spaces")
  """
  def validate_format(changeset, opts \\ []) do
    field = Keyword.get(opts, :field, :email)
    # Use Ecto's default message if none provided
    # The Ecto default will be translated via gettext to "has invalid format"
    validation_opts = 
      if Keyword.has_key?(opts, :message) do
        [message: Keyword.get(opts, :message)]
      else
        []
      end

    validate_format(changeset, field, @pattern, validation_opts)
  end

  @doc """
  Validates email length.

  Adds a length validation to the changeset for the email field.

  ## Options

    * `:field` - The field to validate (default: `:email`)
    * `:max` - Maximum length (default: 160)

  ## Examples

      changeset
      |> Email.validate_length()

      changeset
      |> Email.validate_length(max: 200)
  """
  def validate_length(changeset, opts \\ []) do
    field = Keyword.get(opts, :field, :email)
    max = Keyword.get(opts, :max, @max_length)

    validate_length(changeset, field, max: max)
  end

  @doc """
  Validates both email format and length.

  Convenience function that combines `validate_format/2` and `validate_length/2`.

  ## Options

  Accepts same options as both validate_format and validate_length:
    * `:field` - The field to validate (default: `:email`)
    * `:message` - Custom error message for format validation
    * `:max` - Maximum length (default: 160)

  ## Examples

      changeset
      |> Email.validate_all()

      changeset
      |> Email.validate_all(field: :contact_email, max: 200)
  """
  def validate_all(changeset, opts \\ []) do
    changeset
    |> validate_format(opts)
    |> validate_length(opts)
  end
end
