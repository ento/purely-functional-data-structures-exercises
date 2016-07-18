defmodule Ch03LeftistHeapTest do
  use ExUnit.Case
  import Mock
  import MockHistory
  doctest Funpurr.Ch03.LeftistHeap
  alias Funpurr.Ch03.LeftistHeap, as: LHeap
  alias Heap.Empty, as: E

  describe "Funpurr.Ch03.LeftistHeap.rank/1" do
    test "rank of an empty tree" do
      assert LHeap.rank(%E{}) == 0
    end

    test "rank of a non-empty tree" do
      assert LHeap.rank(LHeap.make_leaf('a')) == 1
    end
  end

  describe "Funpurr.Ch03.LeftistHeap.merge/2" do
    test "merging a tree with an empty tree" do
      tree = LHeap.make_leaf('a')
      assert Heap.merge(tree, %E{}) == tree
    end

    test "merging an empty tree with a tree" do
      tree = LHeap.make_leaf('a')
      assert Heap.merge(%E{}, tree) == tree
    end

    test "merging h1 with h2" do
      h1 = LHeap.make_leaf('h1')
      h2 = LHeap.make_leaf('h2')
      expected = %LHeap{
        rank: 1,
        elem: 'h1',
        left: h2,
        right: %E{},
      }
      assert Heap.merge(h1, h2) == expected
    end

    test "merging h2 with h1" do
      h1 = LHeap.make_leaf('h1')
      h2 = LHeap.make_leaf('h2')
      expected = %LHeap{
        rank: 1,
        elem: 'h1',
        left: h2,
        right: %E{},
      }
      assert Heap.merge(h2, h1) == expected
    end
  end

  describe "Funpurr.Ch03.LeftistHeap.insert/2" do
    test "insert h1 to empty" do
      assert LHeap.insert_through_merge(%E{}, 'h1') == LHeap.make_leaf('h1')
      assert_raise ArgumentError, fn ->
        Heap.insert(%E{}, 'h1')
      end
    end

    test "insert h1 to h2" do
      expected = %LHeap{
        rank: 1,
        elem: 'h1',
        left: LHeap.make_leaf('h2'),
        right: %E{},
      }
      assert LHeap.insert_through_merge(LHeap.make_leaf('h2'), 'h1') == expected
      assert Heap.insert(LHeap.make_leaf('h2'), 'h1') == expected
    end

    test "insert h1 to h2-h3-h4" do
      target = %LHeap{
        rank: 2,
        elem: 'h2',
        left: LHeap.make_leaf('h3'),
        right: LHeap.make_leaf('h4'),
      }
      expected = %LHeap{
        rank: 1,
        elem: 'h1',
        left: target,
        right: %E{},
      }
      assert LHeap.insert_through_merge(target, 'h1') == expected
      assert Heap.insert(target, 'h1') == expected
    end
  end

  describe "Funpurr.Ch03.LeftistHeap.from_list/1" do
    test_with_mock "empty list", LHeap, [:passthrough], [] do
      assert LHeap.from_list([]) == %E{}
      assert num_calls(LHeap.merge_list(:_)) == 0
    end

    test_with_mock "single element", LHeap, [:passthrough], [] do
      assert LHeap.from_list([1]) == LHeap.make_leaf(1)
      assert num_calls(LHeap.merge_list(:_)) == 0
    end

    test_with_mock "four elements", LHeap, [:passthrough], [] do
      expected = %LHeap{
        rank: 2,
        elem: 1,
        left: LHeap.make_leaf(2),
        right: %LHeap{
          rank: 1,
          elem: 3,
          left: LHeap.make_leaf(4),
          right: %E{},
        },
      }
      assert LHeap.from_list([1, 2, 3, 4]) == expected
      assert num_calls(LHeap.from_list(:_)) == 1
      assert num_calls(LHeap.merge_list(:_)) == 2
    end
  end
end
