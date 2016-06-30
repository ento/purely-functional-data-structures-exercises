defmodule Ch03Test do
  use ExUnit.Case
  doctest Funpurr.Ch03
  alias Funpurr.Ch03.LeftistHeap, as: Heap

  test "rank of an empty tree" do
    assert Heap.rank(Heap.empty()) == 0
  end

  test "rank of a non-empty tree" do
    tree = %Heap.Tree{
      rank: 1,
      elem: 'hello',
      left: Heap.empty(),
      right: Heap.empty()}
    assert Heap.rank(tree) == 1
  end
end
