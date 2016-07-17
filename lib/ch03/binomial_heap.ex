defmodule Funpurr.Ch03.BinomialHeap do
  # datatype Heap = Tree list
  @type heap(a) :: list(Node.t(a))

  # datatype Tree = Node of int x Elem.T x Tree list
  defmodule Node do
    @type t(a) :: %Node{rank: non_neg_integer, elem: a, children: list(Node.t(a))}
    defstruct [:rank, :elem, :children]
  end

  @spec empty() :: heap(any)
  def empty(), do: []

  @spec rank(Node.t) :: non_neg_integer
  def rank(%Node{rank: rank}), do: rank

  @spec root(Node.t(a)) :: a when a: any
  def root(%Node{elem: elem}), do: elem

  @spec link(Node.t, Node.t) :: Node.t
  def link(
    t1 = %Node{rank: rank1, elem: elem1, children: children1},
    t2 = %Node{elem: elem2, children: children2}) do
    if elem1 <= elem2 do
      %Node{rank: rank1 + 1, elem: elem1, children: [t2 | children1]}
    else
      %Node{rank: rank1 + 1, elem: elem2, children: [t1 | children2]}
    end
  end

  @spec insert(a, heap(a)) :: heap(a) when a: any
  def insert(elem, heap) do
    ins_tree(%Node{rank: 0, elem: elem, children: []}, heap)
  end

  defp ins_tree(t, []), do: [t]
  defp ins_tree(t1, t2 = [t2_head | t2_tail]) do
    if rank(t1) < rank(t2_head) do
      [t1 | t2]
    else
      ins_tree(link(t1, t2_head), t2_tail)
    end
  end

  @spec merge(heap(a), heap(a)) :: heap(a) when a: any
  def merge(h, []), do: h
  def merge([], h), do: h
  def merge([head1 | tail1] = heap1, [head2 | tail2] = heap2) do
    if rank(head1) < rank(head2) do
      [head1 | merge(tail1, heap2)]
    else
      if rank(head2) < rank(head1) do
        [head2 | merge(heap1, tail2)]
      else
        ins_tree(link(head1, head2), merge(tail1, tail2))
      end
    end
  end

  @spec find_min(heap(a)) :: a when a: any
  def find_min(ts) do
    {t, _} = remove_min_tree(ts)
    root(t)
  end

  defp remove_min_tree([h]), do: {h, []}
  defp remove_min_tree([h | t]) do
    {t_min, t_rest} = remove_min_tree(t)
    if root(h) <= root(t_min) do
      {h, t}
    else
      {t_min, [h | t_rest]}
    end
  end

  @spec delete_min(heap(a)) :: heap(a) when a: any
  def delete_min(heap) do
    {%Node{children: min_children}, rest} = remove_min_tree(heap)
    merge(Enum.reverse(min_children), rest)
  end
end
