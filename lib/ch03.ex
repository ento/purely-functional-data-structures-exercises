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
  end
end
