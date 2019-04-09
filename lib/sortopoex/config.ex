defmodule Sortopoex.Config do
  @moduledoc """
  Run-time configurations for Sortopoex
  """
  @behaviour Confex.Adapter
  # alias Confex.Resolver

  require Logger

  @doc """
  Configure expose through SSL
  """
  def fetch_value("SORTOPOEX_EXPOSED_VIA_SSL") do
    {:ok,
     case System.get_env("SORTOPOEX_EXPOSED_VIA_SSL") do
       "true" -> "https"
       _ -> "http"
     end}
  end

  def fetch_value(_), do: :error
end
