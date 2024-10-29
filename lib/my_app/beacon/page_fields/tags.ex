defmodule MyApp.Beacon.PageFields.Tags do
  @moduledoc """
  Custom beacon page field to store tags for a blog post.

  Tags are separated by commas.
  """

  use Phoenix.Component
  import Beacon.Web.CoreComponents
  import Ecto.Changeset

  @behaviour Beacon.Content.PageField

  @impl true
  def name, do: :tags

  @impl true
  def type, do: :string

  @impl true
  def default, do: "2024"

  @impl true
  def render(assigns) do
    ~H"""
    <.input type="text" label="Tags" field={@field} />
    """
  end

  @impl true
  def changeset(data, attrs, _metadata) do
    cast(data, attrs, [:tags])
  end
end
