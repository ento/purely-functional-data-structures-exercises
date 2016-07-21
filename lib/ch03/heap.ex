defprotocol Heap do
  defmodule Empty do
    defstruct []
  end
  @fallback_to_any true
  def empty?(heap)
  def member?(heap, x)
  def find_min(heap)
  def insert(heap, x)
  def merge(heap1, heap2)
  def delete_min(heap)
end

defimpl Heap, for: Any do
  def empty?(%Heap.Empty{}), do: true
  def empty?(_), do: false
  def member?(%Heap.Empty{}, _), do: false
  def find_min(%Heap.Empty{}), do: :error
  def merge(%Heap.Empty{}, h), do: h
  def insert(%Heap.Empty{}, a), do: raise ArgumentError
end
