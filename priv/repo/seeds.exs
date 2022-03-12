# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Snownix.Repo.insert!(%Snownix.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule Snownix.Seeds do
  import Ecto.Query, only: [from: 2]

  alias Snownix.Repo
  alias Snownix.Posts.Post
  alias Snownix.Posts.Entity
  alias Snownix.Accounts.User

  def import_demo() do
    insert_demo_users()
    insert_demo_posts()
  end

  def insert_demo_users() do
    Repo.insert_all(User, [
      %{
        username: "jone",
        fullname: "Jone Doe",
        phone: "+212612345678",
        email: "jone@snownix.io",
        hashed_password: "jonepassword",
        confirmed_at: ~N[2022-01-10 12:01:10],
        inserted_at: ~N[2022-01-10 12:01:10],
        updated_at: ~N[2022-01-20 12:01:10],
        admin: true
      }
    ])
  end

  @doc """
  Those are only demo blog for testing, source medium
  """
  def insert_demo_posts() do
    posts = [
      %{
        slug: "creating-a-mobile-design-system",
        title: "Creating a mobile design system",
        description:
          "Design systems have been in the spotlight for the past few years, but are still underrepresented in the native apps space. This article will shine some light on mobile design systems, and provide you with practical steps and principles to consider when creating your own mobile design system.",
        poster: "https://miro.medium.com/max/1400/0*GJJIRw7qxRFgnmAf.png",
        published_at: ~N[2022-01-15 12:01:10],
        inserted_at: ~N[2022-01-10 12:01:10],
        updated_at: ~N[2022-01-20 12:01:10],
        author_id: select_random_user_id()
      },
      %{
        title: "Leave Aside Git Checkout. Consider Git Switch for a Change",
        slug: "leave-aside-git-checkout-consider-git-switch-for-a-change",
        description:
          "Without looking any further can you tell straight away what git checkout command does? I have asked my team and myself. Nobody including me was able to give a full answer. First, what comes to mind is switching between existing branches. Running a command git checkout main will switch from the current to the branch main. That is a correct answer yet not full.",
        poster: "https://miro.medium.com/max/770/0*Ye4kcynKFGPVzkYm",
        published_at: ~N[2022-01-15 12:01:10],
        inserted_at: ~N[2022-01-10 12:01:10],
        updated_at: ~N[2022-01-20 12:01:10],
        author_id: select_random_user_id()
      },
      %{
        slug: "factory-method-design-pattern",
        title: "Factory Method Design Pattern",
        description:
          "The factory method design pattern comes under the category of creational patterns because in the factory method design pattern, it defines creation of an object. The factory method design pattern demonstrates define abstract or inheritance class and let the subclasses decide which object to instantiate. In singleton design pattern, end-user always knows which instance it will return but, in factory method it will return sub instances. As a result of that object instantiation logic is hidden to the end-user.",
        poster: "https://miro.medium.com/max/770/1*Lc8AYOW4QWzl4iVJOerbwQ.jpeg",
        published_at: ~N[2022-01-15 12:01:10],
        inserted_at: ~N[2022-01-10 12:01:10],
        updated_at: ~N[2022-01-20 12:01:10],
        author_id: select_random_user_id()
      }
    ]

    {_, items} = Repo.insert_all(Post, posts, returning: [:id])

    items
    |> Enum.map(fn post ->
      generate_random_entities(post)
    end)
  end

  defp generate_random_entities(post) do
    Enum.to_list(1..5)
    |> Enum.map(fn order ->
      Repo.insert(%Entity{
        post_id: post.id,
        body: Faker.Lorem.paragraphs(2..3) |> Enum.join("\n"),
        type: "text",
        order: order
      })
    end)
  end

  defp select_random_user_id() do
    query =
      from t in User,
        order_by: fragment("RANDOM()"),
        limit: 1

    case Repo.all(query) |> List.first() do
      user -> user.id
      _ -> nil
    end
  end
end

if Application.get_env(:snownix, :environment) == :prod do
  # prod branch
else
  # dev/test branch
  Snownix.Seeds.import_demo()
end
