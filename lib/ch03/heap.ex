defprotocol Heap do # (H: Heap) : Heap =
  @fallback_to_any true
  # structure Elem = H.Elem
  # datatype Heap = E | NE of Elem.T x H.Heap
  def find_min(heap)
  def insert(heap, x)
  def merge(heap1, heap2)
  def delete_min(heap)
end

defimpl Heap, for: Any do
  def merge(:empty, h), do: h
end
