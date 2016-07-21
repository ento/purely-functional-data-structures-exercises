defmodule Funpurr.Ch03.RedBlackTree do
  defstruct [:color, :left, :elem, :right]
  defmodule Empty do
    defstruct []
  end

  def make_leaf(elem, color \\ :red) do
    %RBTree{
      color: color,
      left: %RBTree.Empty{},
      elem: elem,
      right: %RBTree.Empty{}}
  end
end

defimpl Heap, for: Funpurr.Ch03.RedBlackTree do
  alias Funpurr.Ch03.RedBlackTree, as: T

  def member?(%T{left: left, elem: y, right: _}, x) when x < y do
    member?(left, x)
  end
  def member?(%T{left: _, elem: y, right: right}, x) when x > y do
    member?(right, x)
  end
  def member?(%T{left: _, elem: y, right: right}, x) do
    true
  end

  def insert(tree, x) do
    %T{left: left, elem: y, right: right} = balanced_insert(tree, x)
    %T{color: :black, left: left, elem: y, right: right}
  end

  defp balanced_insert(%T.Empty{}, x), do: T.make_leaf(x)
  defp balanced_insert(
    %T{color: color, left: left, elem: y, right: right} = tree,
    x) do
    if x < y do
      balance(color, balanced_insert(left, x), y, right)
    else if x > y do
      balance(color, left, y, balanced_insert(right, x))
    end
      tree
    end
  end

  defp balance(
    :black,
    %T{color: :red,
       left: %T{color: :red, left: a, elem: x, right: b},
       elem: y,
       right: c},
    z, d), do
    %T{color: :red,
       left: %T{color: :black, left: a, elem: x, right: b},
       elem: y,
       right: %T{color: :black, left: c, elem: z, right: d}}
  end

  defp balance(
    :black,
    %T{color: :red,
       left: a,
       elem: x,
       right: %T{color: :red, left: b, elem: y, right: c}},
    z, d) do
    %T{color: :red,
       left: %T{color: :black, left: a, elem: x, right: b},
       elem: y,
       right: %T{color: :black, left: c, elem: z, right: d}}
  end
  defp balance(
    :black, a, x,
    %T{color: :red,
       left: %T{color: :red, left: b, elem: y, right: c},
       elem: z,
       right: d}) do
    %T{color: :red,
       left: %T{color: :black, left: a, elem: x, right: b},
       elem: y,
       right: %T{color: :black, left: c, elem: z, right: d}}
  end
  defp balance(
    :black, a, x,
    %T{color: :red,
       left: b,
       elem: y,
       right: %T{color: :red, left: c, elem: z, right: d}}) do
    %T{color: :red,
       left: %T{color: :black, left: a, elem: x, right: b},
       elem: y,
       right: %T{color: :black, left: c, elem: z, right: d}}
  end
  defp balance(color, left, x, right) do
    %T{color: color, left: left, elem: x, right: right}
  end
end
