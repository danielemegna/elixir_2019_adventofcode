defmodule Advent3 do

  def resolve_first_part do
    [first_wire_movements, second_wire_movements] = read_wire_movements_from_file()
    find_closest_cross_manhattan_distance(first_wire_movements, second_wire_movements)
  end

  def resolve_second_part do
    [first_wire_movements, second_wire_movements] = read_wire_movements_from_file()
    find_fewest_combined_steps_to_cross(first_wire_movements, second_wire_movements)
  end

  def find_closest_cross_manhattan_distance(first_wire_movements, second_wire_movements) do
    first_grid_coordinates = %{}
      |> fill_grid_with(first_wire_movements)
      |> Map.keys
    second_grid_coordinates = %{}
      |> fill_grid_with(second_wire_movements)
      |> Map.keys
    
    MapSet.intersection(MapSet.new(first_grid_coordinates), MapSet.new(second_grid_coordinates))
      |> Enum.map(fn {x, y} -> abs(x) + abs(y) end)
      |> Enum.min
  end

  def find_fewest_combined_steps_to_cross(first_wire_movements, second_wire_movements) do
    first_grid = %{} |> fill_grid_with(first_wire_movements)
    second_grid = %{} |> fill_grid_with(second_wire_movements)

    first_grid
      |> Enum.filter(fn {coordinate, _} -> Map.has_key?(second_grid, coordinate) end)
      |> Enum.map(fn {coordinate, first_wire_length} ->
        second_wire_length = Map.get(second_grid, coordinate)
        first_wire_length + second_wire_length
      end)
      |> Enum.min
  end

  def fill_grid_with(grid, movements), do: fill_grid_with(grid, movements, {0,0}, 0)
  def fill_grid_with(grid, [movement | rest], current_coordinate, current_wire_length) do
    {direction, steps_number} = String.split_at(movement, 1)
    {steps_number, _} = Integer.parse(steps_number)

    new_grid = 1..steps_number
      |> Enum.reduce(grid, fn step_index, acc ->
        step_coordinate = increase_coordinate(current_coordinate, direction, step_index)
        step_wire_length = current_wire_length + step_index
        Map.put(acc, step_coordinate, step_wire_length)
      end)
    new_coordinate = increase_coordinate(current_coordinate, direction, steps_number)
    new_wire_length = current_wire_length + steps_number

    fill_grid_with(new_grid, rest, new_coordinate, new_wire_length)
  end
  def fill_grid_with(grid, [], _, _), do: grid

  defp increase_coordinate({x, y}, "R", count), do: {x + count, y}
  defp increase_coordinate({x, y}, "L", count), do: {x - count, y}
  defp increase_coordinate({x, y}, "U", count), do: {x, y + count}
  defp increase_coordinate({x, y}, "D", count), do: {x, y - count}

  defp read_wire_movements_from_file do
    File.stream!("advent3.txt")
      |> Enum.map(&(String.split(&1, ",")))
  end

end
