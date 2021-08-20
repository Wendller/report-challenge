defmodule GenReport do
  alias GenReport.Hours
  alias GenReport.Hours_Per_Month
  alias GenReport.Hours_Per_Year

  def build(filename) do
    %{
      "all_hours" => Hours.build_all_hours(filename),
      "hours_per_month" => Hours_Per_Month.build_hours_per_month(filename),
      "hours_per_year" => Hours_Per_Year.build_hours_per_year(filename)
    }
  end

  def build do
    {:error, "Insira o nome de um arquivo"}
  end
end
