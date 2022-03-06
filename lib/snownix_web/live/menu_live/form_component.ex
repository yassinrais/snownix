defmodule SnownixWeb.MenuLive.FormComponent do
  use SnownixWeb, :live_component

  alias Snownix.Navigation

  @impl true
  def update(%{menu: menu} = assigns, socket) do
    changeset = Navigation.change_menu(menu)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"menu" => menu_params}, socket) do
    changeset =
      socket.assigns.menu
      |> Navigation.change_menu(menu_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"menu" => menu_params}, socket) do
    save_menu(socket, socket.assigns.action, menu_params)
  end

  defp save_menu(socket, :edit, menu_params) do
    case Navigation.update_menu(socket.assigns.menu, menu_params) do
      {:ok, _menu} ->
        {:noreply,
         socket
         |> put_flash(:info, "Menu updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_menu(socket, :new, menu_params) do
    case Navigation.create_menu(menu_params) do
      {:ok, _menu} ->
        {:noreply,
         socket
         |> put_flash(:info, "Menu created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
