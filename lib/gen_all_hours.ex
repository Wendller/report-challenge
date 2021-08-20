defmodule GenReport.Hours do
  alias GenReport.Parser

  def build_all_hours(filename) do
    "#{filename}"
    |> Parser.parse_file()
    |> Enum.reduce(acc_hours(filename), fn parsed_line, report ->
      sum_all_hours(parsed_line, report)
    end)
  end

  def get_names(filename) do
    "#{filename}"
    |> Parser.parse_file()
    |> Enum.map(&List.first(&1))
    |> Enum.frequencies()
    |> Map.keys()
  end

  defp acc_hours(filename) do
    Enum.into(get_names(filename), %{}, &{&1, 0})
  end

  defp sum_all_hours([name, hours, _day, _month, _year], report) do
    Map.put(report, name, report[name] + hours)
  end
end
