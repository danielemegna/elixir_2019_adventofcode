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
    first_grid_coordinates = []
      |> fill_grid_with(first_wire_movements, {0,0}, 0)
      |> Enum.map(&(&1.coordinate))
    second_grid_coordinates = []
      |> fill_grid_with(second_wire_movements, {0,0}, 0)
      |> Enum.map(&(&1.coordinate))
    
    MapSet.intersection(MapSet.new(first_grid_coordinates), MapSet.new(second_grid_coordinates))
      |> Enum.map(fn {x, y} -> abs(x) + abs(y) end)
      |> Enum.min
  end

  def find_fewest_combined_steps_to_cross(first_wire_movements, second_wire_movements) do
    first_grid = [] |> fill_grid_with(first_wire_movements, {0,0}, 0)
    second_grid = [] |> fill_grid_with(second_wire_movements, {0,0}, 0)

    first_grid
      |> Enum.map(fn first ->
        second = Enum.find(second_grid, fn second ->
          first.coordinate == second.coordinate 
        end)
        if(second != nil) do
          [first, second]
        else
          nil
        end
      end)
      |> Enum.filter(& !is_nil(&1))
      |> Enum.map(fn [first, second] ->
        first.wire_length + second.wire_length
      end)
      |> Enum.min
  end

  def fill_grid_with(grid, [movement | rest], current_coordinate, current_wire_length) do
    {direction, steps_number} = String.split_at(movement, 1)
    {steps_number, _} = Integer.parse(steps_number)

    occupied_coordinates = 1..steps_number |> Enum.map(fn(step_index) ->
      step_coordinate = increase_coordinate(current_coordinate, direction, step_index)
      %{ coordinate: step_coordinate, wire_length: current_wire_length + step_index }
    end)

    new_grid = grid ++ occupied_coordinates
    new_coordinate = increase_coordinate(current_coordinate, direction, steps_number)

    fill_grid_with(new_grid, rest, new_coordinate, current_wire_length + steps_number)
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
