defmodule Funpurr.Ch03.MinTaggedHeap do
  @type t(a, b) :: %__MODULE__{min: a, heap: b}
  defstruct [:min, :heap]

  def from_heap(heap) do
    if Heap.empty?(heap) do
      %Heap.Empty{}
    else
      {:ok, min} = Heap.find_min(heap)
      %__MODULE__{min: min, heap: heap}
    end
  end
end

defimpl Heap, for: Funpurr.Ch03.MinTaggedHeap do
  alias Funpurr.Ch03.MinTaggedHeap, as: MinTaggedHeap

  def find_min(%MinTaggedHeap{min: min}), do: {:ok, min}

  def insert(%MinTaggedHeap{min: min, heap: heap}, x) do
    new_min = if min < x, do: min, else: x
    %MinTaggedHeap{min: new_min, heap: Heap.insert(heap, x)}
  end

  def merge(%MinTaggedHeap{} = heap, %Heap.Empty{}), do: heap
  def merge(
    %MinTaggedHeap{min: min1, heap: heap1},
    %MinTaggedHeap{min: min2, heap: heap2}) do
    new_min = if min1 < min2, do: min1, else: min2
    %MinTaggedHeap{min: new_min, heap: Heap.merge(heap1, heap2)}
  end

  def delete_min(%MinTaggedHeap{heap: heap}) do
    deleted = Heap.delete_min(heap)
    if Heap.empty?(deleted) do
      %Heap.Empty{}
    else
      {:ok, min} = Heap.find_min(deleted)
      %MinTaggedHeap{min: min, heap: deleted}
    end
  end
end
