defmodule Advent4Test do
  use ExUnit.Case

  test "password meets_criteria? test" do
    assert true == Advent4.meets_criteria?(111111)
    assert false == Advent4.meets_criteria?(223450)
    assert false == Advent4.meets_criteria?(123789)
  end

  @tag :skip
  test "resolve level (first part)" do
    assert 19 == Advent4.resolve
  end


end
