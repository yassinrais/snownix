reset:
	@mix ecto.drop
	@mix ecto.setup

serve:
	@iex -S mix phx.server
