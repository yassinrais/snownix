defmodule SnownixWeb.PostLive.New do
  use SnownixWeb, :live_view

  alias Snownix.Posts
  alias Snownix.Posts.Post
  alias Snownix.Posts.Entity
  alias Snownix.Posts.Category

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_post()
     |> assign_uploads()
     |> assign_multiselect()
     |> assign(:markdown, true)
     |> assign(:custom_slug, false)
     |> assign(:fullscreen, false)}
  end

  defp assign_multiselect(socket) do
    socket
    |> assign(:categories, [])
    |> assign(:query_categories, nil)
    |> update_list_categories()
  end

  defp assign_uploads(socket) do
    socket
    |> assign(:uploaded_files, [])
    |> allow_upload(:images, accept: ~w(.jpg .jpeg .png .gif), auto_upload: true, max_entries: 1)
  end

  defp assign_post(socket) do
    entities = [
      %Entity{
        body:
          "**Prerequisites**\nYou will have a much easier time understanding the ways for setting up the MongoDB to PostgreSQL connection if you have gone through the following aspects:\n\n* An active MongoDB account.\n* Ac active PostgreSQL account.\n* Working knowledge of Databases.\n* Clear idea regarding the type of data to be transferred.\n\n**Method 1**: Manual ETL Process to Set Up MongoDB to PostgreSQL Integration\n\nThis would need you to deploy engineering resources to extract data from MongoDB, convert the JSON output to CSV, and load data to PostgreSQL.\n\nMethod 2: Using Hevo Data to Set Up MongoDB to PostgreSQL Integration\n\nHevo Data is an automated Data Pipeline platform that can move your data from MongoDB to PostgreSQL very quickly without writing a single line of code. It is simple, hassle-free, and reliable.\n\nMoreover, Hevo offers a fully-managed solution to set up data integration from MongoDB and 100+ other data sources (including 30+ free data sources) and will let you directly load data to Databases such as PostgreSQL, Data Warehouses, or the destination of your choice. It will automate your data flow in minutes without writing any line of code. Its Fault-Tolerant architecture makes sure that your data is secure and consistent. Hevo provides you with a truly efficient and fully automated solution to manage data in real-time and always have analysis-ready data."
      }
    ]

    post = %Post{
      title: "How to Migrate from Mongodb to Postgresql",
      description:
        "DMS is a great tool which can be used to migrate data between different types of databases – including Mongo to Postgres transfer",
      entities: entities,
      published_at: NaiveDateTime.utc_now(),
      categories: []
    }

    socket
    |> assign(:post, post)
    |> assign(:changeset, Posts.change_post(post))
  end

  defp update_list_categories(socket) do
    socket
    |> assign(
      :list_categories,
      Posts.list_categories(socket.assigns.query_categories)
    )
    |> filter_list_categories()
  end

  defp filter_list_categories(socket) do
    socket
    |> assign(
      :list_categories,
      socket.assigns.list_categories
      |> Enum.reject(fn category ->
        socket.assigns.categories
        |> Enum.find(&(&1.id == category.id))
      end)
    )
  end

  def update_multiselect(socket, :categories, query) do
    socket |> assign(:query_categories, query) |> update_list_categories()
  end

  def handle_event("validate", %{"post" => post_params}, socket) do
    %{"query_categories" => query_categories} = post_params

    changeset =
      socket.assigns.post
      |> Posts.change_post(post_params, custom_slug: socket.assigns.custom_slug)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> update_multiselect(:categories, query_categories)
     |> assign(:changeset, changeset)}
  end

  def handle_event(socket, "custom-slug", _) do
    socket |> assign(:custom_slug, true)
  end

  def handle_event("create", %{"post" => post_params}, socket) do
    author = socket.assigns.current_user
    categories = socket.assigns.categories

    case Posts.create_post(author, post_params, categories) do
      {:ok, post} ->
        consume_uploaded_entries(socket, :images, fn meta, entry ->
          {:ok,
           Posts.update_post_poster(post, %Plug.Upload{
             content_type: entry.client_type,
             filename: entry.client_name,
             path: meta.path
           })}
        end)

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> assign(:changeset, changeset)
         |> put_changeset_errors(changeset)}
    end
  end

  def handle_event("tfullscreen", _, socket) do
    {:noreply, socket |> assign(:fullscreen, !socket.assigns.fullscreen)}
  end

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :images, ref)}
  end

  @doc """
  Append/Drop item to multiselect
  """
  def handle_event("multiselect", %{"list" => list_name, "item" => item, "type" => type}, socket) do
    category = String.to_atom(list_name)

    case type do
      "add" ->
        {:noreply,
         socket
         |> append_item_to_list(category, item)
         |> filter_list_categories()}

      _ ->
        {:noreply,
         socket
         |> drop_item_from_list(category, item)
         |> update_list_categories()}
    end
  end

  defp append_item_to_list(socket, :categories, %{"id" => id, "title" => title}) do
    title = title |> String.trim()

    case Enum.find(socket.assigns.categories, &(&1.id == id || &1.title == title)) do
      nil ->
        category =
          socket.assigns.list_categories
          |> Enum.find(fn c -> c.id == id end)

        socket
        |> assign(
          :categories,
          [
            case is_nil(category) do
              true ->
                case Snownix.Helper.generate_slug(%{title: title}) do
                  %{slug: slug} ->
                    %Category{id: get_id(), title: title, slug: slug}

                  _ ->
                    nil
                end

              _ ->
                category
            end
            | socket.assigns.categories
          ]
          |> Enum.reject(&is_nil(&1))
        )

      _ ->
        socket
    end
  end

  defp append_item_to_list(socket, :categories, id) when is_binary(id) do
    id = id |> String.trim()

    case socket.assigns.list_categories |> Enum.find(&(&1.id == id || &1.title == id)) do
      %Category{id: cat_id, title: title} ->
        socket |> append_item_to_list(:categories, %{"id" => cat_id, "title" => title})

      _ ->
        socket
    end
  end

  defp append_item_to_list(socket, _, _), do: socket

  defp drop_item_from_list(socket, :categories, id) when is_binary(id) do
    socket |> assign(:categories, socket.assigns.categories |> Enum.filter(&(&1.id != id)))
  end

  defp drop_item_from_list(socket, _, _), do: socket

  defp get_id, do: Ecto.UUID.generate()
end
