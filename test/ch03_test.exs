defmodule Ch03Test do
  use ExUnit.Case
  doctest Funpurr.Ch03
  alias Funpurr.Ch03.LeftistHeap, as: Heap

  test "rank of an empty tree" do
    assert Heap.rank(Heap.empty()) == 0
  end

  test "rank of a non-empty tree" do
    assert Heap.rank(leaf()) == 1
  end

  test "merging a tree with an empty tree" do
    tree = leaf()
    assert Heap.merge(tree, Heap.empty()) == tree
  end

  test "merging an empty tree with a tree" do
    tree = leaf()
    assert Heap.merge(Heap.empty(), tree) == tree
  end

  test "merging h1 with h2" do
    h1 = leaf('h1')
    h2 = leaf('h2')
    expected = %Heap.Tree{
      rank: 1,
      elem: 'h1',
      left: h2,
      right: Heap.empty(),
    }
    assert Heap.merge(h1, h2) == expected
  end

  test "merging h2 with h1" do
    h1 = leaf('h1')
    h2 = leaf('h2')
    expected = %Heap.Tree{
      rank: 1,
      elem: 'h1',
      left: h2,
      right: Heap.empty(),
    }
    assert Heap.merge(h2, h1) == expected
  end

  test "insert h1 to empty" do
    assert Heap.insert_through_merge('h1', Heap.empty()) == leaf('h1')
    assert Heap.insert('h1', Heap.empty()) == leaf('h1')
  end

  test "insert h1 to h2" do
    expected = %Heap.Tree{
      rank: 1,
      elem: 'h1',
      left: leaf('h2'),
      right: Heap.empty(),
    }
    assert Heap.insert_through_merge('h1', leaf('h2')) == expected
    assert Heap.insert('h1', leaf('h2')) == expected
  end

  test "insert h1 to h2-h3-h4" do
    target = %Heap.Tree{
      rank: 2,
      elem: 'h2',
      left: leaf('h3'),
      right: leaf('h4'),
    }
    expected = %Heap.Tree{
      rank: 1,
      elem: 'h1',
      left: target,
      right: Heap.empty(),
    }
    assert Heap.insert_through_merge('h1', target) == expected
    assert Heap.insert('h1', target) == expected
  end

  defp leaf(elem \\ 'hello', rank \\ 1) do
    %Heap.Tree{
      rank: rank,
      elem: elem,
      left: Heap.empty(),
      right: Heap.empty()}
  end
end
