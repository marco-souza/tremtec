defmodule Tremtec.Config do
  @moduledoc """
  Central configuration for Tremtec application.

  This module serves as a single source of truth for application-wide
  configuration values, particularly those used in multiple places.
  """

  @doc """
  Returns the list of supported locales for the application.
  """
  def supported_locales, do: ["pt", "en", "es"]

  @doc """
  Returns the default locale when no preference is detected.
  """
  def default_locale, do: "en"
end
