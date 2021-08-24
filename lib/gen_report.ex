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

  def build_from_many(filenames) do
    filenames
    |> Task.async_stream(fn filename -> build(filename) end)
    |> Enum.reduce(acc_report("gen_report.csv"), fn {:ok, result}, report ->
      sum_reports_values(result, report)
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

  defp merge_maps(map1, map2) do
    Map.merge(map1, map2, fn _key, value1, value2 -> value1 + value2 end)
  end

  def sum_reports_values(result, report) do
    all_hours_sum = merge_maps(result["all_hours"], report["all_hours"])

    hours_per_month = %{
      "cleiton" =>
        merge_maps(report["hours_per_month"]["cleiton"], result["hours_per_month"]["cleiton"]),
      "daniele" =>
        merge_maps(report["hours_per_month"]["daniele"], result["hours_per_month"]["daniele"]),
      "danilo" =>
        merge_maps(report["hours_per_month"]["danilo"], result["hours_per_month"]["danilo"]),
      "diego" =>
        merge_maps(report["hours_per_month"]["diego"], result["hours_per_month"]["diego"]),
      "giuliano" =>
        merge_maps(report["hours_per_month"]["giuliano"], result["hours_per_month"]["giuliano"]),
      "jakeliny" =>
        merge_maps(report["hours_per_month"]["jakeliny"], result["hours_per_month"]["jakeliny"]),
      "joseph" =>
        merge_maps(report["hours_per_month"]["joseph"], result["hours_per_month"]["joseph"]),
      "mayk" => merge_maps(report["hours_per_month"]["mayk"], result["hours_per_month"]["mayk"]),
      "rafael" =>
        merge_maps(report["hours_per_month"]["rafael"], result["hours_per_month"]["rafael"]),
      "vinicius" =>
        merge_maps(report["hours_per_month"]["vinicius"], result["hours_per_month"]["vinicius"])
    }

    hours_per_year = %{
      "cleiton" =>
        merge_maps(report["hours_per_year"]["cleiton"], result["hours_per_year"]["cleiton"]),
      "daniele" =>
        merge_maps(report["hours_per_year"]["daniele"], result["hours_per_year"]["daniele"]),
      "danilo" =>
        merge_maps(report["hours_per_year"]["danilo"], result["hours_per_year"]["danilo"]),
      "diego" => merge_maps(report["hours_per_year"]["diego"], result["hours_per_year"]["diego"]),
      "giuliano" =>
        merge_maps(report["hours_per_year"]["giuliano"], result["hours_per_year"]["giuliano"]),
      "jakeliny" =>
        merge_maps(report["hours_per_year"]["jakeliny"], result["hours_per_year"]["jakeliny"]),
      "joseph" =>
        merge_maps(report["hours_per_year"]["joseph"], result["hours_per_year"]["joseph"]),
      "mayk" => merge_maps(report["hours_per_year"]["mayk"], result["hours_per_year"]["mayk"]),
      "rafael" =>
        merge_maps(report["hours_per_year"]["rafael"], result["hours_per_year"]["rafael"]),
      "vinicius" =>
        merge_maps(report["hours_per_year"]["vinicius"], result["hours_per_year"]["vinicius"])
    }

    %{
      "all_hours" => all_hours_sum,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end
end

# Map.put(
#   report["hours_per_month"]["cleiton"],
#   "abril",
#   report["hours_per_month"]["cleiton"]["abril"] +
#     result["hours_per_month"]["cleiton"]["abril"]
# )
