defmodule Funpurr.Ch03 do
  defmodule LeftistHeap do
    # datatype Heap = E | T of int x Elem.T x Heap x Heap
    @type heap(a) :: Empty.t | Tree.t(a)

    defmodule Empty do
      @type t :: %Empty{}
      defstruct []
    end

    defmodule Tree do
      @type t(a) :: %Tree{rank: integer(), elem: a, left: Tree.t(a), right: Tree.t(a)}
      defstruct [:rank, :elem, :left, :right]
    end

    def empty() do
      %Empty{}
    end

    def rank(%Empty{}), do: 0
    def rank(%Tree{rank: rank}), do: rank

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
      merge(%Tree{rank: 1, elem: elem, left: empty(), right: empty()}, h)
    end

    # exercise 3.2
    def insert(x, %Empty{}), do: make_leaf(1, x)
    def insert(x, h = %Tree{elem: elem, left: left, right: right}) do
      if x <= elem do
        %Tree{rank: 1, elem: x, left: h, right: empty()}
      else
        make_tree(elem, left, insert(x, right))
      end
    end

    defp make_tree(elem, left, right) do
      if rank(left) >= rank(right) do
        %Tree{rank: rank(right) + 1, elem: elem, left: left, right: right}
      else
        %Tree{rank: rank(left) + 1, elem: elem, left: right, right: left}
      end
    end

    defp make_leaf(rank, elem) do
      %Tree{rank: rank, elem: elem, left: empty(), right: empty()}
    end
  end
end
