defmodule Ch03WeightBiasedLeftistHeapTest do
  use ExUnit.Case
  import Mock
  import MockHistory
  doctest Funpurr.Ch03.WeightBiasedLeftistHeap
  alias Funpurr.Ch03.WeightBiasedLeftistHeap, as: Heap

  describe "Funpurr.Ch03.WeightBiasedLeftistHeap.weight/1" do
    test "weight of an empty tree" do
      assert Heap.weight(Heap.empty()) == 0
    end

    test "weight of a non-empty tree" do
      assert Heap.weight(leaf()) == 1
    end
  end

  describe "Funpurr.Ch03.WeightBiasedLeftistHeap.merge/2" do
    test "merging a tree with an empty tree" do
      tree = leaf()
      merged = Heap.merge(tree, Heap.empty())
      assert merged == tree
      assert Heap.weight(merged) == 1
    end

    test "merging an empty tree with a tree" do
      tree = leaf()
      merged = Heap.merge(Heap.empty(), tree)
      assert merged == tree
      assert Heap.weight(merged) == 1
    end

    test "merging h1 with h2" do
      h1 = leaf('h1')
      h2 = leaf('h2')
      expected = %Heap.Tree{
        weight: 2,
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
        weight: 2,
        elem: 'h1',
        left: h2,
        right: Heap.empty(),
      }
      assert Heap.merge(h2, h1) == expected
    end
  end

  describe "Funpurr.Ch03.WeightBiasedLeftistHeap.insert/2" do
    test "insert h1 to empty" do
      assert Heap.insert_through_merge('h1', Heap.empty()) == leaf('h1')
      assert Heap.insert('h1', Heap.empty()) == leaf('h1')
    end

    test "insert h1 to h2" do
      expected = %Heap.Tree{
        weight: 2,
        elem: 'h1',
        left: leaf('h2'),
        right: Heap.empty(),
      }
      assert Heap.insert_through_merge('h1', leaf('h2')) == expected
      assert Heap.insert('h1', leaf('h2')) == expected
    end

    test "insert h1 to h2-h3-h4" do
      target = %Heap.Tree{
        weight: 2,
        elem: 'h2',
        left: leaf('h3'),
        right: leaf('h4'),
      }
      expected = %Heap.Tree{
        weight: 3,
        elem: 'h1',
        left: target,
        right: Heap.empty(),
      }
      assert Heap.insert_through_merge('h1', target) == expected
      assert Heap.insert('h1', target) == expected
    end
  end

  describe "Funpurr.Ch03.WeightBiasedLeftistHeap.from_list/1" do
    test_with_mock "empty list", Heap, [:passthrough], [] do
      assert Heap.from_list([]) == Heap.empty()
      assert num_calls(Heap.merge_list(:_)) == 0
    end

    test_with_mock "single element", Heap, [:passthrough], [] do
      assert Heap.from_list([1]) == leaf(1)
      assert num_calls(Heap.merge_list(:_)) == 0
    end

    test_with_mock "four elements", Funpurr.Ch03.WeightBiasedLeftistHeap, [:passthrough], [] do
      expected = %Heap.Tree{
        weight: 4,
        elem: 1,
        left: %Heap.Tree{
          weight: 2,
          elem: 3,
          left: leaf(4),
          right: Heap.empty(),
        },
        right: leaf(2),
      }
      assert Heap.from_list([1, 2, 3, 4]) == expected
      assert num_calls(Heap.from_list(:_)) == 1
      assert num_calls(Heap.merge_list(:_)) == 2
    end
  end

  defp leaf(elem \\ 'hello', weight \\ 1) do
    %Heap.Tree{
      weight: weight,
      elem: elem,
      left: Heap.empty(),
      right: Heap.empty()}
  end
end