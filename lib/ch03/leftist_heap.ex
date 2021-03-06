defmodule Funpurr.Ch03.LeftistHeap do
  alias Heap.Empty, as: E

  @type t(a) :: %__MODULE__{rank: integer(), elem: a, left: __MODULE__.t(a), right: __MODULE__.t(a)}
  defstruct [:rank, :elem, :left, :right]

  def rank(%E{}), do: 0
  def rank(%__MODULE__{rank: rank}), do: rank

  # exercise 3.3
  def from_list([]), do: %E{}
  def from_list([h]), do: make_leaf(h)
  def from_list(l) do
    __MODULE__.merge_list Enum.map(l, &(make_leaf/1))
  end

  def make_leaf(elem) do
    %__MODULE__{rank: 1, elem: elem, left: %E{}, right: %E{}}
  end

  def insert_through_merge(h, elem) do
    Heap.merge(%__MODULE__{rank: 1, elem: elem, left: %E{}, right: %E{}}, h)
  end

  # needs to be public to be able to call this through __MODULE__,
  # which in turn is needed to count calls through meck/mock.
  def merge_list(l) do
    merged = [h | t] =
      Enum.chunk(l, 2, 2, [%E{}])
      |> Enum.map(fn pair -> apply Heap, :merge, pair end)
    case t do
      [] ->
        h
      [%E{}] ->
        h
      _ ->
        __MODULE__.merge_list merged
    end
  end
end

defimpl Heap, for: Funpurr.Ch03.LeftistHeap do
  alias Funpurr.Ch03.LeftistHeap, as: LeftistHeap
  alias Heap.Empty, as: E

  def merge(h, %E{}), do: h
  def merge(
    h1 = %LeftistHeap{elem: elem1, left: left1, right: right1},
    h2 = %LeftistHeap{elem: elem2, left: left2, right: right2}) do
    if elem1 <= elem2 do
      make_tree(elem1, left1, Heap.merge(right1, h2))
    else
      make_tree(elem2, left2, Heap.merge(h1, right2))
    end
  end

  # exercise 3.2
  def insert(%LeftistHeap{elem: elem, left: left, right: right} = h, x) do
    if x <= elem do
      %LeftistHeap{rank: 1, elem: x, left: h, right: %E{}}
    else
      make_tree(elem, left, insert(right, x))
    end
  end

  defp make_tree(elem, left, right) do
    if LeftistHeap.rank(left) >= LeftistHeap.rank(right) do
      %LeftistHeap{rank: LeftistHeap.rank(right) + 1, elem: elem, left: left, right: right}
    else
      %LeftistHeap{rank: LeftistHeap.rank(left) + 1, elem: elem, left: right, right: left}
    end
  end
end
