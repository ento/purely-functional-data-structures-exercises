defmodule Ch03MinTaggedHeapTest do
  use ExUnit.Case
  doctest Funpurr.Ch03.MinTaggedHeap
  alias Funpurr.Ch03.MinTaggedHeap, as: MHeap
  alias Funpurr.Ch03.BinomialHeap, as: BHeap

  describe "Funpurr.Ch03.MinTaggedHeap.merge/2" do
    test "merging a leaf heap <> an empty heap" do
      heap = MHeap.from_heap(BHeap.from_elem('a'))
      empty = MHeap.from_heap(BHeap.empty())
      assert Heap.merge(heap, empty) == heap
      assert Heap.merge(empty, heap) == heap
    end

    test "merging h1 <> h2" do
      h1 = MHeap.from_heap(BHeap.from_elem('h1'))
      h2 = MHeap.from_heap(BHeap.from_elem('h2'))
      assert Heap.find_min(Heap.merge(h1, h2)) == {:ok, 'h1'}
      assert Heap.find_min(Heap.merge(h2, h1)) == {:ok, 'h1'}
    end
  end

  describe "Funpurr.Ch03.MinTaggedHeap.insert/2" do
    test "insert 'a' to empty" do
      empty = MHeap.from_heap(BHeap.empty())
      assert_raise ArgumentError, fn ->
        Heap.insert(empty, 'a')
      end
    end

    test "insert a to b" do
      b = MHeap.from_heap(BHeap.from_elem('b'))
      assert Heap.find_min(Heap.insert(b, 'a')) == {:ok, 'a'}
    end

    test "insert b to a" do
      a = MHeap.from_heap(BHeap.from_elem('a'))
      assert Heap.find_min(Heap.insert(a, 'b')) == {:ok, 'a'}
    end
  end

  describe "Funpurr.Ch03.MinTaggedHeap.find_min/1" do
    test "min of leaf a" do
      a = MHeap.from_heap(BHeap.from_elem('a'))
      assert Heap.find_min(a) == {:ok, 'a'}
    end
  end

  describe "Funpurr.Ch03.MinTaggedHeap.delete_min/1" do
    test "delete min of leaf a" do
      a = MHeap.from_heap(BHeap.from_elem('a'))
      empty = MHeap.from_heap(BHeap.empty())
      assert Heap.delete_min(a) == empty
    end
  end
end
