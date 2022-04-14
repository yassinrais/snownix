defmodule SnownixWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS

  @meta_list %{
    "title" => %{field: :page_title, default: "Snownix"},
    "description" => %{field: :page_desc, default: nil},
    "keywords" => %{field: :page_keywords, default: nil},
    "og:title" => %{field: :page_title, default: "Snownix"},
    "og:image" => %{field: :page_image, default: nil},
    "og:type" => %{field: :page_ogtype, default: "website"},
    "og:url" => %{field: :page_url, default: nil},
    "og:description" => %{field: :page_desc, default: nil},
    "og:site_name" => %{field: :page_sitename, default: "Snownix"},
    "twitter:card" => %{field: :page_twitter_card, default: "summary"},
    "twitter:title" => %{field: :page_title, default: "Snownix"},
    "twitter:site" => %{field: :page_url, default: nil},
    "twitter:image:src" => %{field: :page_image, default: nil},
    "twitter:creator" => %{field: :page_author, default: "Snownix"},
    "twitter:description" => %{field: :page_desc, default: nil},
    "robots" => %{field: :page_robots, default: "index, follow"},
    "language" => %{field: :page_lang, default: "English"}
  }

  @doc """
  Renders a live component inside a modal.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <.modal return_to={Routes.menu_index_path(@socket, :index)}>
        <.live_component
          module={SnownixWeb.MenuLive.FormComponent}
          id={@menu.id || :new}
          title={@page_title}
          action={@live_action}
          return_to={Routes.menu_index_path(@socket, :index)}
          menu: @menu
        />
      </.modal>
  """
  def modal(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)

    ~H"""
    <div id="modal" class="phx-modal fade-in" phx-remove={hide_modal()}>
      <div
        id="modal-content"
        class="phx-modal-content fade-in-scale"
        phx-click-away={JS.dispatch("click", to: "#close")}
        phx-window-keydown={JS.dispatch("click", to: "#close")}
        phx-key="escape"
      >
        <%= if @return_to do %>
          <%= live_patch "✖",
            to: @return_to,
            id: "close",
            class: "phx-modal-close",
            phx_click: hide_modal()
          %>
        <% else %>
         <a id="close" href="#" class="phx-modal-close" phx-click={hide_modal()}>✖</a>
        <% end %>

        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end

  @doc """
  Get list of active menus
  if cache exists return cache list
  else fetch fresh list
  """
  def list_menu() do
    menus = Cachex.get!(:snownix, "list_active_menus")

    if is_nil(menus) do
      menus =
        Snownix.Navigation.list_active_menus()
        |> map_menu_subs()

      Cachex.put!(:snownix, "list_active_menus", menus)

      menus
    else
      menus
    end
  end

  defp map_menu_item(item), do: [%{item: item, sub: []}]

  def map_menu_subs(menus) do
    menus
    |> Enum.reduce([], fn item, list ->
      if is_nil(item.parent_id) do
        list ++ map_menu_item(item)
      else
        Enum.map(list, fn parent ->
          if parent.item.id == item.parent_id do
            Map.merge(parent, %{
              sub: parent.sub ++ map_menu_item(item)
            })
          else
            parent
          end
        end)
      end
    end)
  end

  @doc """
  Format naive date
  """
  def article_date_format(nil), do: nil

  def article_date_format(naive_date) do
    naive_date |> DateTime.from_naive!("Etc/UTC") |> Calendar.strftime("%a, %B %d %Y")
  end

  @split_pattern [" ", "\n", "\r", "\t"]
  @words_per_minute 200

  @doc """
  Returns the time in minutes for a given string.
  ## Examples
      iex> reading_time("An article content")
      1
      iex> reading_time("An_article_content", words_per_minute: 1, split_pattern: ["_", "-"])
      5
  """
  def reading_time(string, opts \\ []) do
    words_per_minute = Keyword.get(opts, :words_per_minute, @words_per_minute)
    split_pattern = Keyword.get(opts, :split_pattern, @split_pattern)

    words =
      string
      |> String.split(split_pattern, trim: true)
      |> length

    minutes =
      Float.ceil(words / words_per_minute)
      |> trunc

    minutes
  end

  @doc """
  Assign meta tags
  """
  def put_meta_tags(socket, params \\ %{}) do
    socket
    |> assign(params)
  end

  @doc """
  Generate meta tags using available assigns data
  """
  def put_meta_tags_list(assigns) do
    meta_tags =
      @meta_list
      |> Enum.reduce("", fn {name, %{field: field, default: default}}, metas ->
        if is_nil(assigns[field]) && is_nil(default) do
          metas
        else
          ~H"""
          <%= metas %>
          <%= generate_meta_tag(name, assigns[field] || default) %>
          """
        end
      end)

    if assigns[:page_image] do
      ~H"""
      <%= meta_tags %>
      <meta content="summary_large_image" name="twitter:card">
      """
    else
      meta_tags
    end
  end

  def generate_meta_tag(name, content, assigns \\ %{}) do
    ~H"""
      <meta name={name} content={content}>
    """
  end

  def tag_has_error(form, field) do
    form.errors
    |> Keyword.get_values(field)
    |> Enum.count() > 0
  end
end
