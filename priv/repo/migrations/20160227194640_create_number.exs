defmodule TakeAnumber.Repo.Migrations.CreateNumber do
  use Ecto.Migration

  def change do
    create table(:numbers) do
      add :served, :boolean, default: false

      timestamps
    end

  end
end
