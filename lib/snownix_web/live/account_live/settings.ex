defmodule SnownixWeb.AccountLive.Settings do
  use SnownixWeb, :live_view

  alias Snownix.Accounts
  alias Snownix.Avatar

  @tabs ["My Details", "Security", "Notifications"]
  def mount(_, _, socket) do
    {:ok,
     socket
     |> assign(:tabs, @tabs)
     |> allow_upload(:avatar,
       accept: ~w(.jpg .jpeg .png .gif),
       max_entries: 1,
       auto_upload: true,
       progress: &handle_progress/3
     )
     |> assign(:tab, select_tab())}
  end

  def handle_event("switch-tab", %{"tab" => tab}, socket) do
    {:noreply, socket |> assign(:tab, select_tab(tab))}
  end

  def handle_event("validate", _, socket) do
    {:noreply, socket}
  end

  def handle_event("delete-avatar", _, socket) do
    case Accounts.update_user_avatar(socket.assigns.current_user, nil) do
      {:ok, user} ->
        {:noreply, socket |> assign(:current_user, user)}

      _ ->
        {:noreply, socket}
    end
  end

  defp handle_progress(:avatar, entry, socket) do
    if entry.done? do
      current_user = socket.assigns.current_user

      uploaded_files =
        consume_uploaded_entries(socket, :avatar, fn %{path: path}, entry ->
          filename = "#{current_user.id}#{Path.extname(entry.client_name)}"
          dest = "/uploads/avatars/#{filename}"
          Avatar.save_avatar(path, dest)
          {:ok, Routes.static_path(socket, dest)}
        end)

      avatar = uploaded_files |> List.first()

      if !is_nil(avatar) do
        case Accounts.update_user_avatar(current_user, avatar) do
          {:ok, user} ->
            {:noreply, socket |> assign(:current_user, user)}

          _ ->
            {:noreply, socket}
        end
      else
        {:noreply, socket}
      end
    else
      {:noreply, socket}
    end
  end

  # Tabs
  defp select_tab(tab \\ nil) do
    Enum.find(@tabs, List.first(@tabs), &(&1 == tab))
  end

  def is_active_tab(current, tab) do
    current == tab
  end

  # Upload messages
  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
