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
       max_file_size: 2_000_000,
       auto_upload: true,
       progress: &handle_progress/3
     )
     |> assign(:tab, select_tab())
     |> assign(:changeset, socket.assigns.current_user |> Accounts.user_changeset(%{}))}
  end

  def handle_event("switch-tab", %{"tab" => tab}, socket) do
    {:noreply, socket |> assign(:tab, select_tab(tab))}
  end

  def handle_event("details-validate", %{"user" => user_params}, socket) do
    {:noreply,
     socket
     |> clear_flash()
     |> assign(
       :changeset,
       socket.assigns.current_user
       |> Accounts.user_changeset(user_params)
       |> Map.put(:action, :validate)
     )}
  end

  def handle_event("details-save", %{"user" => user_params}, socket) do
    user = socket.assigns.current_user

    %{"current_password" => password} = user_params

    case Accounts.update_user(user, password, user_params) do
      {:ok, user} ->
        {:noreply,
         socket
         |> assign(:current_user, user)
         |> assign(:changeset, Accounts.user_changeset(user, user_params))
         |> put_flash(:success, gettext("Account information updated successfully."))}

      {:error, changeset} ->
        {:noreply, socket |> assign(:changeset, changeset)}
    end
  end

  # Avatar
  def handle_event("validate", _, socket), do: {:noreply, socket}

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
  defp error_to_string(:too_large), do: gettext("File size is too large, max allowed 2MB.")
  defp error_to_string(:too_many_files), do: gettext("You have selected too many files.")

  defp error_to_string(:not_accepted),
    do: gettext("You have selected an unacceptable file type, only images are accepted.")
end
