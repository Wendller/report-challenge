defmodule GenReport.Hours_Per_Month do
  alias GenReport.Parser

  @months %{
    1 => "janeiro",
    2 => "fevereiro",
    3 => "março",
    4 => "abril",
    5 => "maio",
    6 => "junho",
    7 => "julho",
    8 => "agosto",
    9 => "setembro",
    10 => "outubro",
    11 => "novembro",
    12 => "dezembro"
  }

  def build_hours_per_month(filename) do
    "#{filename}"
    |> Parser.parse_file()
    |> Enum.reduce(acc_hours_per_month(filename), fn parsed_line, report ->
      sum_hours_per_month(parsed_line, report)
    end)
  end

  def get_names(filename) do
    "#{filename}"
    |> Parser.parse_file()
    |> Enum.map(&List.first(&1))
    |> Enum.frequencies()
    |> Map.keys()
  end

  defp acc_hours_per_month(filename) do
    Enum.into(
      get_names(filename),
      %{},
      &{&1, Enum.into(1..12, %{}, fn num -> {@months[num], 0} end)}
    )
  end

  defp sum_hours_per_month([name, hours, _day, month, _year], report) do
    Map.put(
      report,
      name,
      Map.put(report[name], month, report[name][month] + hours)
    )
  end
end
