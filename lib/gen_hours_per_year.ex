defmodule GenReport.Hours_Per_Year do
  alias GenReport.Parser

  @years [
    2016,
    2017,
    2018,
    2019,
    2020
  ]

  def build_hours_per_year(filename) do
    "#{filename}"
    |> Parser.parse_file()
    |> Enum.reduce(acc_hours_per_years(filename), fn parsed_line, report ->
      sum_hours_per_year(parsed_line, report)
    end)
  end

  def get_names(filename) do
    "#{filename}"
    |> Parser.parse_file()
    |> Enum.map(&List.first(&1))
    |> Enum.frequencies()
    |> Map.keys()
  end

  defp acc_hours_per_years(filename) do
    Enum.into(get_names(filename), %{}, &{&1, Enum.into(@years, %{}, fn year -> {year, 0} end)})
  end

  defp sum_hours_per_year([name, hours, _day, _month, year], report) do
    Map.put(
      report,
      name,
      Map.put(report[name], year, report[name][year] + hours)
    )
  end
end
