defmodule Sortopoex.Tasks do
  @moduledoc """
  Tasks context collects behaviors related to Tasks
  """

  @doc """
  Topologically sorts given Tasks
  Uses http://erlang.org/doc/man/digraph_utils.html

  ## Examples

      iex> sort([%{"name" => 1, "requires" => [2]}, %{"name" => 2}])
      {:ok, [%{"name" => 2}, %{"name" => 1, "requires" => [2]}]}

      iex> sort([%{"name" => 1, "requires" => [2]}, %{"name" => 2, "requires" => [1]}])
      {:error, "Failed to sort tasks, there is acyclic dependency"}

      iex> sort([%{"name" => 1}, %{"name" => 2}])
      {:ok, [%{"name" => 2}, %{"name" => 1}]}

      iex> sort([])
      {:ok, []}
  """
  @spec sort(list) :: {:error, binary} | {:ok, [any]}
  def sort(tasks) when is_list(tasks) do
    lookup = tasks |> Enum.reduce(%{}, fn elem, acc -> Map.put(acc, elem["name"], elem) end)
    graph = :digraph.new()

    Enum.each(tasks, fn %{"name" => name} = task ->
      :digraph.add_vertex(graph, name)
      requrements = task["requires"] || []
      Enum.each(requrements, fn req -> add_dependency(graph, name, req) end)
    end)

    with {:is_acyclic, true} <- {:is_acyclic, :digraph_utils.is_acyclic(graph)},
         {:sort, sorted} when not is_boolean(sorted) <- {:sort, :digraph_utils.topsort(graph)} do
      {:ok, sorted |> Enum.map(&lookup[&1])}
    else
      {:is_acyclic, false} -> {:error, "Failed to sort tasks, there is acyclic dependency"}
      {:sort, false} -> {:error, "Failed to sort tasks"}
    end
  end

  defp add_dependency(_graph, task, task), do: :ok

  defp add_dependency(graph, task, requirements) do
    :digraph.add_vertex(graph, requirements)
    :digraph.add_edge(graph, requirements, task)
  end
end
