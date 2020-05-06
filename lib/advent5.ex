defmodule Advent5 do

  def resolve do
    read_initial_memory_from_file()
      |> run_memory_program_with_input(1)
  end

  def run_memory_program_from_instruction(memory, instruction_pointer) do
    instruction = Enum.slice(memory, instruction_pointer, 4)
    if(halt_program_instruction?(instruction)) do
      memory
    else
      memory
        |> compute_instruction(instruction)
        |> run_memory_program_from_instruction(instruction_pointer + 4)
    end
  end

  defp run_memory_program_with_input(memory, _input) do
    memory
  end

  defp read_initial_memory_from_file do
    File.stream!("advent5.txt")
      |> Enum.at(0)
      |> String.split(",")
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(fn({n, _}) -> n end)
  end

  defp halt_program_instruction?(instruction) do
    case(instruction) do
      [99 | _] -> true
      _ -> false
    end
  end

  defp compute_instruction(memory, [opcode, first_parameter_position, second_parameter_position, result_position]) do
    first_parameter = Enum.at(memory, first_parameter_position)
    second_parameter = Enum.at(memory, second_parameter_position)
    instruction_result = case(opcode) do
      1 -> first_parameter + second_parameter
      2 -> first_parameter * second_parameter
    end
    List.replace_at(memory, result_position, instruction_result)
  end

end

defmodule Instruction do
  defstruct opcode: 1, first_parameter_mode: 0, second_parameter_mode: 0, third_parameter_mode: 0

  def build_from(code) do
    %Instruction{
      opcode: rem(code, 100),
      first_parameter_mode: rem(div(code, 100), 10),
      second_parameter_mode: rem(div(code, 1000), 10),
      third_parameter_mode: div(code, 10000)
    }
  end

end
