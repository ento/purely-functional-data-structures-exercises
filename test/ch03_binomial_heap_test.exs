defmodule Ch03BinomialHeapTest do
  use ExUnit.Case
  doctest Funpurr.Ch03.BinomialHeap
  alias Funpurr.Ch03.BinomialHeap, as: Heap

  describe "Funpurr.Ch03.BinomialHeap.rank/1" do
    test "rank of a leaf" do
      assert Heap.rank(leaf()) == 0
    end

    test "rank of a non-empty tree" do
      assert Heap.rank(%Heap.Node{rank: 1, elem: 'x', children: []}) == 1
    end
  end

  describe "Funpurr.Cha3.BinomialHeap.link/2" do
    test "link a and b" do
      expected = %Heap.Node{rank: 1, elem: 'a', children: [leaf('b')]}
      assert Heap.link(leaf('a'), leaf('b')) == expected
      assert Heap.link(leaf('b'), leaf('a')) == expected
    end

    test "link a-b and c-d" do
      heap_a_b = %Heap.Node{rank: 1, elem: 'a', children: [leaf('b')]}
      heap_c_d = %Heap.Node{rank: 1, elem: 'c', children: [leaf('d')]}
      expected = %Heap.Node{
        rank: 2,
        elem: 'a',
        children: [
          heap_c_d,
          leaf('b'),
        ]}
      assert Heap.link(heap_a_b, heap_c_d) == expected
      assert Heap.link(heap_c_d, heap_a_b) == expected
    end
  end

  describe "Funpurr.Ch03.BinomialHeap.merge/2" do
    test "merging a leaf heap with an empty heap" do
      heap = [leaf()]
      assert Heap.merge(heap, Heap.empty()) == heap
    end

    test "merging an empty heap with a leaf heap" do
      heap = [leaf()]
      assert Heap.merge(Heap.empty(), heap) == heap
    end

    test "merging h1 with h2" do
      h1 = [leaf('h1')]
      h2 = [leaf('h2')]
      expected = %Heap.Node{
        rank: 1,
        elem: 'h1',
        children: h2,
      }
      assert Heap.merge(h1, h2) == [expected]
    end

    test "merging h2 with h1" do
      h1 = [leaf('h1')]
      h2 = [leaf('h2')]
      expected = %Heap.Node{
        rank: 1,
        elem: 'h1',
        children: h2,
      }
      assert Heap.merge(h2, h1) == [expected]
    end
  end

  describe "Funpurr.Ch03.BinomialHeap.insert/2" do
    test "insert 'a' to empty" do
      assert Heap.insert('a', Heap.empty()) == [leaf('a')]
    end

    test "insert a to b" do
      a_b = %Heap.Node{
        rank: 1,
        elem: 'a',
        children: [leaf('b')],
      }
      assert Heap.insert('a', [leaf('b')]) == [a_b]
    end

    test "insert a to b_c" do
      b_c = %Heap.Node{
        rank: 1,
        elem: 'b',
        children: [leaf('c')],
      }
      assert Heap.insert('a', [b_c]) == [leaf('a'), b_c]
    end
  end

  describe "Funpurr.Ch03.BinomialHeap.find_min/1" do
    test "min of empty" do
      assert_raise FunctionClauseError, fn ->
        Heap.find_min(Heap.empty())
      end
    end

    test "min of leaf a" do
      assert Heap.find_min([leaf('a')]) == 'a'
    end

    test "min of [c, a_b]" do
      a_b = %Heap.Node{
        rank: 1,
        elem: 'a',
        children: [leaf('b')],
      }
      c_a_b = Heap.insert('c', [a_b])
      assert Heap.find_min(c_a_b) == 'a'
    end
  end

  describe "Funpurr.Ch03.BinomialHeap.delete_min/1" do
    test "delete min of empty" do
      assert_raise FunctionClauseError, fn ->
        Heap.delete_min(Heap.empty())
      end
    end

    test "delete min of leaf a" do
      assert Heap.delete_min([leaf('a')]) == []
    end

    test "delete min of [e_f, a_b_c_d]" do
      e_f_a_b_c_d = from_list(['a', 'b', 'c', 'd', 'e', 'f'])
      assert Enum.map(e_f_a_b_c_d, &Heap.rank/1) == [1, 2]
      assert Enum.map(Heap.delete_min(e_f_a_b_c_d), &Heap.rank/1) == [0, 2]
      assert Heap.delete_min(e_f_a_b_c_d) == from_list(['f', 'e', 'd', 'c', 'b'])
    end
  end

  defp leaf(elem \\ 'hello') do
    %Heap.Node{
      rank: 0,
      elem: elem,
      children: []}
  end

  defp from_list(list) do
    List.foldl(
      list,
      Heap.empty(),
      fn(x, acc) -> Heap.insert(x, acc) end)
  end
end
