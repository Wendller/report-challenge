defmodule GenReport do
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

  @years [
    2016,
    2017,
    2018,
    2019,
    2020
  ]

  def build(filename) do
    "#{filename}"
    |> Parser.parse_file()
    |> Enum.reduce(acc_report(filename), fn parsed_line, report ->
      sum_report_values(parsed_line, report)
    end)
  end

  def build do
    {:error, "Insira o nome de um arquivo"}
  end

  defp get_names(filename) do
    "#{filename}"
    |> Parser.parse_file()
    |> Enum.map(&List.first(&1))
    |> Enum.frequencies()
    |> Map.keys()
  end

  defp acc_report(filename) do
    %{
      "all_hours" => acc_hours(filename),
      "hours_per_month" => acc_hours_per_month(filename),
      "hours_per_year" => acc_hours_per_years(filename)
    }
  end

  defp acc_hours(filename) do
    Enum.into(get_names(filename), %{}, &{&1, 0})
  end

  defp acc_hours_per_month(filename) do
    Enum.into(
      get_names(filename),
      %{},
      &{&1, Enum.into(1..12, %{}, fn num -> {@months[num], 0} end)}
    )
  end

  defp acc_hours_per_years(filename) do
    Enum.into(get_names(filename), %{}, &{&1, Enum.into(@years, %{}, fn year -> {year, 0} end)})
  end

  defp sum_report_values([name, hours, _day, month, year], report) do
    all_hours = Map.put(report["all_hours"], name, report["all_hours"][name] + hours)

    hours_per_month =
      Map.put(
        report["hours_per_month"],
        name,
        Map.put(
          report["hours_per_month"][name],
          month,
          report["hours_per_month"][name][month] + hours
        )
      )

    hours_per_year =
      Map.put(
        report["hours_per_year"],
        name,
        Map.put(
          report["hours_per_year"][name],
          year,
          report["hours_per_year"][name][year] + hours
        )
      )

    report
    |> Map.put("all_hours", all_hours)
    |> Map.put("hours_per_month", hours_per_month)
    |> Map.put("hours_per_year", hours_per_year)
  end
end
