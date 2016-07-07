defmodule Funpurr.Ch03.WeightBiasedLeftistHeap do
  @type heap(a) :: Empty.t | Tree.t(a)

  defmodule Empty do
    @type t :: %Empty{}
    defstruct []
  end

  defmodule Tree do
    @type t(a) :: %Tree{weight: integer(), elem: a, left: Tree.t(a), right: Tree.t(a)}
    defstruct [:weight, :elem, :left, :right]
  end

  def empty() do
    %Empty{}
  end

  def weight(%Empty{}), do: 0
  def weight(%Tree{weight: weight}), do: weight

  def merge(h, %Empty{}), do: h
  def merge(%Empty{}, h), do: h
  def merge(
    h1 = %Tree{elem: elem1, left: left1, right: right1},
    h2 = %Tree{elem: elem2, left: left2, right: right2}) do
    if elem1 <= elem2 do
      make_tree(elem1, left1, merge(right1, h2))
    else
      make_tree(elem2, left2, merge(h1, right2))
    end
  end

  def insert_through_merge(elem, h) do
    merge(%Tree{weight: 1, elem: elem, left: empty(), right: empty()}, h)
  end

  # exercise 3.2
  def insert(x, %Empty{}), do: make_leaf(x)
  def insert(x, h = %Tree{elem: elem, left: left, right: right}) do
    if x <= elem do
      %Tree{weight: weight(h) + 1, elem: x, left: h, right: empty()}
    else
      make_tree(elem, left, insert(x, right))
    end
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
      |> Enum.map(fn pair -> apply __MODULE__, :merge, pair end)
    case t do
      [] ->
        h
      [%Empty{}] ->
        h
      _ ->
        __MODULE__.merge_list merged
    end
  end

  defp make_tree(elem, left, right) do
    if weight(left) >= weight(right) do
      %Tree{weight: weight(right) + weight(left) + 1, elem: elem, left: left, right: right}
    else
      %Tree{weight: weight(right) + weight(left) + 1, elem: elem, left: right, right: left}
    end
  end

  defp make_leaf(elem) do
    %Tree{weight: 1, elem: elem, left: empty(), right: empty()}
  end
end
