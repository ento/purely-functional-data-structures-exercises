defmodule Ch03WeightBiasedLeftistHeapTest do
  use ExUnit.Case
  import Mock
  import MockHistory
  doctest Funpurr.Ch03.WeightBiasedLeftistHeap
  alias Funpurr.Ch03.WeightBiasedLeftistHeap, as: WBLHeap
  alias Heap.Empty, as: E

  describe "Funpurr.Ch03.WeightBiasedLeftistHeap.weight/1" do
    test "weight of an empty tree" do
      assert WBLHeap.weight(%E{}) == 0
    end

    test "weight of a non-empty tree" do
      assert WBLHeap.weight(WBLHeap.make_leaf('a')) == 1
    end
  end

  describe "Funpurr.Ch03.WeightBiasedLeftistHeap.merge/2" do
    test "merging a tree with an empty tree" do
      tree = WBLHeap.make_leaf('a')
      merged = Heap.merge(tree, %E{})
      assert merged == tree
      assert WBLHeap.weight(merged) == 1
    end

    test "merging an empty tree with a tree" do
      tree = WBLHeap.make_leaf('a')
      merged = Heap.merge(%E{}, tree)
      assert merged == tree
      assert WBLHeap.weight(merged) == 1
    end

    test "merging h1 with h2" do
      h1 = WBLHeap.make_leaf('h1')
      h2 = WBLHeap.make_leaf('h2')
      expected = %WBLHeap{
        weight: 2,
        elem: 'h1',
        left: h2,
        right: %E{},
      }
      assert Heap.merge(h1, h2) == expected
    end

    test "merging h2 with h1" do
      h1 = WBLHeap.make_leaf('h1')
      h2 = WBLHeap.make_leaf('h2')
      expected = %WBLHeap{
        weight: 2,
        elem: 'h1',
        left: h2,
        right: %E{},
      }
      assert Heap.merge(h2, h1) == expected
    end
  end

  describe "Funpurr.Ch03.WeightBiasedLeftistHeap.insert/2" do
    test "insert h1 to empty" do
      assert WBLHeap.insert_through_merge(%E{}, 'h1') == WBLHeap.make_leaf('h1')
      assert_raise ArgumentError, fn ->
        Heap.insert(%E{}, 'h1')
      end
    end

    test "insert h1 to h2" do
      expected = %WBLHeap{
        weight: 2,
        elem: 'h1',
        left: WBLHeap.make_leaf('h2'),
        right: %E{},
      }
      assert WBLHeap.insert_through_merge(WBLHeap.make_leaf('h2'), 'h1') == expected
      assert Heap.insert(WBLHeap.make_leaf('h2'), 'h1') == expected
    end

    test "insert h1 to h2-h3-h4" do
      target = %WBLHeap{
        weight: 2,
        elem: 'h2',
        left: WBLHeap.make_leaf('h3'),
        right: WBLHeap.make_leaf('h4'),
      }
      expected = %WBLHeap{
        weight: 3,
        elem: 'h1',
        left: target,
        right: %E{},
      }
      assert WBLHeap.insert_through_merge(target, 'h1') == expected
      assert Heap.insert(target, 'h1') == expected
    end
  end

  describe "Funpurr.Ch03.WeightBiasedLeftistHeap.from_list/1" do
    test_with_mock "empty list", WBLHeap, [:passthrough], [] do
      assert WBLHeap.from_list([]) == %E{}
      assert num_calls(WBLHeap.merge_list(:_)) == 0
    end

    test_with_mock "single element", WBLHeap, [:passthrough], [] do
      assert WBLHeap.from_list([1]) == WBLHeap.make_leaf(1)
      assert num_calls(WBLHeap.merge_list(:_)) == 0
    end

    test_with_mock "four elements", Funpurr.Ch03.WeightBiasedLeftistHeap, [:passthrough], [] do
      expected = %WBLHeap{
        weight: 4,
        elem: 1,
        left: %WBLHeap{
          weight: 2,
          elem: 3,
          left: WBLHeap.make_leaf(4),
          right: %E{},
        },
        right: WBLHeap.make_leaf(2),
      }
      assert WBLHeap.from_list([1, 2, 3, 4]) == expected
      assert num_calls(WBLHeap.from_list(:_)) == 1
      assert num_calls(WBLHeap.merge_list(:_)) == 2
    end
  end
end
