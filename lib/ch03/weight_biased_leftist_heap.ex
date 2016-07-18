defmodule Funpurr.Ch03.WeightBiasedLeftistHeap do
  @type t(a) :: %__MODULE__{weight: integer(), elem: a, left: __MODULE__.t(a), right: __MODULE__.t(a)}
  defstruct [:weight, :elem, :left, :right]

  def empty() do
    :empty
  end

  def weight(:empty), do: 0
  def weight(%__MODULE__{weight: weight}), do: weight

  def insert_through_merge(h, elem) do
    Heap.merge(%__MODULE__{weight: 1, elem: elem, left: empty(), right: empty()}, h)
  end

  # exercise 3.3
  def from_list([]), do: empty()
  def from_list([h]), do: make_leaf(h)
  def from_list(l) do
    __MODULE__.merge_list Enum.map(l, &(make_leaf/1))
  end

  # needs to be public to be able to call this through __MODULE__,
  # which in turn is needed to count calls through meck/mock.
  def merge_list(l) do
    merged = [h | t] =
      Enum.chunk(l, 2, 2, [empty()])
      |> Enum.map(fn pair -> apply Heap, :merge, pair end)
    case t do
      [] ->
        h
      [:empty] ->
        h
      _ ->
        __MODULE__.merge_list merged
    end
  end

  def make_leaf(elem) do
    %__MODULE__{weight: 1, elem: elem, left: empty(), right: empty()}
  end
end

defimpl Heap, for: Funpurr.Ch03.WeightBiasedLeftistHeap do
  alias Funpurr.Ch03.WeightBiasedLeftistHeap, as: WBLHeap
  def merge(h, :empty), do: h
  def merge(:empty, h), do: h
  def merge(
    h1 = %WBLHeap{elem: elem1, left: left1, right: right1},
    h2 = %WBLHeap{elem: elem2, left: left2, right: right2}) do
    if elem1 <= elem2 do
      make_weighted_tree(elem1, left1, right1, h2)
    else
      make_weighted_tree(elem2, left2, h1, right2)
    end
  end

  # exercise 3.2
  def insert(h = %WBLHeap{elem: elem, left: left, right: right}, x) do
    if x <= elem do
      %WBLHeap{weight: WBLHeap.weight(h) + 1, elem: x, left: h, right: WBLHeap.empty()}
    else
      make_tree(elem, left, Heap.insert(right, x))
    end
  end

  # exercise 3.4 (c)
  defp make_weighted_tree(elem, left, right1, right2) do
    right_weight = WBLHeap.weight(right1) + WBLHeap.weight(right2)
    left_weight = WBLHeap.weight(left)
    if left_weight >= right_weight do
      %WBLHeap{
        weight: right_weight + left_weight + 1,
        elem: elem,
        left: left,
        right: Heap.merge(right1, right2)}
    else
      %WBLHeap{
        weight: right_weight + left_weight + 1,
        elem: elem,
        left: Heap.merge(right1, right2),
        right: left}
    end
  end

  defp make_tree(elem, left, right) do
    if WBLHeap.weight(left) >= WBLHeap.weight(right) do
      %WBLHeap{
        weight: WBLHeap.weight(right) + WBLHeap.weight(left) + 1,
        elem: elem,
        left: left,
        right: right}
    else
      %WBLHeap{
        weight: WBLHeap.weight(right) + WBLHeap.weight(left) + 1,
        elem: elem,
        left: right,
        right: left}
    end
  end
end
