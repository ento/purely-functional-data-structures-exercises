defmodule Ch03BinomialHeapTest do
  use ExUnit.Case
  doctest Funpurr.Ch03.BinomialHeap
  alias Funpurr.Ch03.BinomialHeap, as: BHeap

  describe "Funpurr.Ch03.BinomialHeap.rank/1" do
    test "rank of an empty root" do
      assert BHeap.rank(BHeap.make_root('a')) == 0
    end

    test "rank of a non-empty tree" do
      assert BHeap.rank({1, %BHeap.Node{elem: 'x', children: []}}) == 1
    end
  end

  describe "Funpurr.Cha3.BinomialHeap.link/2" do
    test "link a and b" do
      expected = {1, %BHeap.Node{elem: 'a', children: [BHeap.make_leaf('b')]}}
      assert BHeap.link(BHeap.make_root('a'), BHeap.make_root('b')) == expected
      assert BHeap.link(BHeap.make_root('b'), BHeap.make_root('a')) == expected
    end

    test "link a-b and c-d" do
      root_a_b = {1, %BHeap.Node{elem: 'a', children: [BHeap.make_leaf('b')]}}
      leaf_c_d = %BHeap.Node{elem: 'c', children: [BHeap.make_leaf('d')]}
      root_c_d = {1, leaf_c_d}
      expected = {2, %BHeap.Node{
        elem: 'a',
        children: [
          leaf_c_d,
          BHeap.make_leaf('b'),
        ]}}
      assert BHeap.link(root_a_b, root_c_d) == expected
      assert BHeap.link(root_c_d, root_a_b) == expected
    end
  end

  describe "Funpurr.Ch03.BinomialHeap.merge/2" do
    test "merging a leaf heap with an empty heap" do
      heap = BHeap.from_elem('a')
      assert Heap.merge(heap, BHeap.empty()) == heap
    end

    test "merging an empty heap with a leaf heap" do
      heap = BHeap.from_elem('a')
      assert Heap.merge(BHeap.empty(), heap) == heap
    end

    test "merging h1 with h2" do
      h1 = BHeap.from_elem('h1')
      h2 = BHeap.make_leaf('h2')
      expected = %BHeap{trees: [{1, %BHeap.Node{
        elem: 'h1',
        children: [h2],
      }}]}
      assert Heap.merge(h1, BHeap.from_elem('h2')) == expected
    end

    test "merging h2 <> h1" do
      h1 = BHeap.from_elem('h1')
      h2 = BHeap.make_leaf('h2')
      expected = %BHeap{trees: [{1, %BHeap.Node{
        elem: 'h1',
        children: [h2],
      }}]}
      assert Heap.merge(BHeap.from_elem('h2'), h1) == expected
      assert Heap.merge(h1, BHeap.from_elem('h2')) == expected
    end

    test "merging a <> b_c" do
      b_c = from_list(['b', 'c'])
      a = BHeap.from_elem('a')
      expected = %BHeap{trees: [BHeap.make_root('a'), {1, %BHeap.Node{
        elem: 'b',
        children: [BHeap.make_leaf('c')],
      }}]}
      assert Heap.merge(a, b_c) == expected
      assert Heap.merge(b_c, a) == expected
    end
  end

  describe "Funpurr.Ch03.BinomialHeap.insert/2" do
    test "insert 'a' to empty" do
      assert Heap.insert(BHeap.empty(), 'a') == BHeap.from_elem('a')
    end

    test "insert a to b" do
      a_b = {1, %BHeap.Node{
        elem: 'a',
        children: [BHeap.make_leaf('b')],
      }}
      assert Heap.insert(BHeap.from_elem('b'), 'a') == %BHeap{trees: [a_b]}
    end

    test "insert a to b_c" do
      b_c = {1, %BHeap.Node{
                elem: 'b',
                children: BHeap.make_leaf('c')}
      }
      a = {0, BHeap.make_leaf('a')}
      assert Heap.insert(%BHeap{trees: [b_c]}, 'a') == %BHeap{trees: [a, b_c]}
    end
  end

  describe "Funpurr.Ch03.BinomialHeap.find_min/1" do
    test "min of empty" do
      assert_raise FunctionClauseError, fn ->
        Heap.find_min(BHeap.empty())
      end
    end

    test "min of leaf a" do
      assert BHeap.find_min_via_remove_min_tree(BHeap.from_elem('a')) == 'a'
      assert Heap.find_min(BHeap.from_elem('a')) == 'a'
    end

    test "min of [c, a_b]" do
      a_b = {1, %BHeap.Node{
        elem: 'a',
        children: [BHeap.make_leaf('b')],
      }}
      c_a_b = Heap.insert(%BHeap{trees: [a_b]}, 'c')
      assert BHeap.find_min_via_remove_min_tree(c_a_b) == 'a'
      assert Heap.find_min(c_a_b) == 'a'
    end
  end

  describe "Funpurr.Ch03.BinomialHeap.delete_min/1" do
    test "delete min of empty" do
      assert_raise FunctionClauseError, fn ->
        Heap.delete_min(BHeap.empty())
      end
    end

    test "delete min of leaf a" do
      assert Heap.delete_min(BHeap.from_elem('a')) == BHeap.empty()
    end

    test "delete min of [e_f, a_b_c_d]" do
      e_f_a_b_c_d = from_list(['a', 'b', 'c', 'd', 'e', 'f'])
      assert Enum.map(e_f_a_b_c_d, &BHeap.rank/1) == [1, 2]
      assert Enum.map(Heap.delete_min(e_f_a_b_c_d), &BHeap.rank/1) == [0, 2]
      assert Heap.delete_min(e_f_a_b_c_d) == from_list(['f', 'e', 'd', 'c', 'b'])
    end
  end

  defp from_list([h | t]) do
    List.foldl(
      t,
      BHeap.from_elem(h),
      fn(x, acc) -> Heap.insert(acc, x) end)
  end
end
