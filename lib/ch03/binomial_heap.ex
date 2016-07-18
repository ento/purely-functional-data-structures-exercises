defmodule Funpurr.Ch03.BinomialHeap do
  # datatype Heap = Tree list
  @type t(a) :: list({non_neg_integer, Node.t(a)})
  defstruct [:trees]

  # datatype Tree = Node of int x Elem.T x Tree list
  defmodule Node do
    @type t(a) :: %Node{elem: a, children: list(Node.t(a))}
    defstruct [:elem, :children]
  end

  @spec empty() :: t(any)
  def empty(), do: %__MODULE__{trees: []}

  @spec from_elem(a) :: t(any) when a: any
  def from_elem(elem) do
    %__MODULE__{trees: [make_root(elem)]}
  end

  @spec make_root(a) :: {non_neg_integer, Note.t(a)} when a: any
  def make_root(elem) do
    {0, make_leaf(elem)}
  end

  @spec make_leaf(a) :: Node.t(a) when a: any
  def make_leaf(elem) do
    %Node{
      elem: elem,
      children: []}
  end

  @spec rank({non_neg_integer, Node.t}) :: non_neg_integer
  def rank({rank, _}), do: rank

  @spec root({non_neg_integer, Node.t(a)}) :: a when a: any
  def root({_, %Node{elem: elem}}), do: elem

  @spec link({non_neg_integer, Node.t}, {non_neg_integer, Node.t}) :: {non_neg_integer, Node.t}
  def link(
    {rank1, %Node{elem: elem1, children: children1} = t1},
    {_, %Node{elem: elem2, children: children2} = t2}) do
    if elem1 <= elem2 do
      {rank1 + 1, %Node{elem: elem1, children: [t2 | children1]}}
    else
      {rank1 + 1, %Node{elem: elem2, children: [t1 | children2]}}
    end
  end

  @spec find_min_via_remove_min_tree(t(a)) :: a when a: any
  def find_min_via_remove_min_tree(ts) do
    {t, _} = remove_min_tree(ts)
    {:ok, root(t)}
  end

  def remove_min_tree(%__MODULE__{trees: [h]}), do: {h, []}
  def remove_min_tree(%__MODULE__{trees: [h | t]}) do
    {t_min, t_rest} = remove_min_tree(%__MODULE__{trees: t})
    if root(h) <= root(t_min) do
      {h, t}
    else
      {t_min, [h | t_rest]}
    end
  end
end

defimpl Heap, for: Funpurr.Ch03.BinomialHeap do
  alias Funpurr.Ch03.BinomialHeap, as: BHeap

  @spec empty?(BHeap.t) :: boolean
  def empty?(%BHeap{trees: []}), do: true
  def empty?(%BHeap{}), do: false

  @spec insert(BHeap.t(a), a) :: BHeap.t(a) when a: any
  def insert(heap, elem) do
    ins_tree(heap, {0, %BHeap.Node{elem: elem, children: []}})
  end

  defp ins_tree(%BHeap{trees: []}, t), do: %BHeap{trees: [t]}
  defp ins_tree(%BHeap{trees: [t2_head | t2_tail] = t2}, t1) do
    if BHeap.rank(t1) < BHeap.rank(t2_head) do
      %BHeap{trees: [t1 | t2]}
    else
      ins_tree(%BHeap{trees: t2_tail}, BHeap.link(t1, t2_head))
    end
  end

  @spec merge(BHeap.t(a), BHeap.t(a)) :: BHeap.t(a) when a: any
  def merge(h, %BHeap{trees: []}), do: h
  def merge(%BHeap{trees: []}, h), do: h
  def merge(
    %BHeap{trees: [head1 | tail1]} = heap1,
    %BHeap{trees: [head2 | tail2]} = heap2) do
    if BHeap.rank(head1) < BHeap.rank(head2) do
      %BHeap{trees: merged} = merge(%BHeap{trees: tail1}, heap2)
      %BHeap{trees: [head1 | merged]}
    else
      if BHeap.rank(head2) < BHeap.rank(head1) do
        %BHeap{trees: merged} = merge(heap1, %BHeap{trees: tail2})
        %BHeap{trees: [head2 | merged]}
      else
        ins_tree(
          merge(%BHeap{trees: tail1}, %BHeap{trees: tail2}),
          BHeap.link(head1, head2))
      end
    end
  end

  # exercise 3.5
  @spec find_min(BHeap.t(a)) :: {:ok, a} | :error when a: any
  def find_min(%BHeap{trees: []}), do: :error
  def find_min(%BHeap{trees: [h]}), do: {:ok, BHeap.root(h)}
  def find_min(%BHeap{trees: [h | t]}) do
    [t_head | t_tail] = t
    if BHeap.root(h) < BHeap.root(t_head) do
      find_min(%BHeap{trees: [h | t_tail]})
    else
      find_min(%BHeap{trees: t})
    end
  end

  @spec delete_min(BHeap.t(a)) :: BHeap.t(a) when a: any
  def delete_min(heap) do
    {{_, %BHeap.Node{children: min_children}}, rest} = BHeap.remove_min_tree(heap)
    ranked_children = Enum.reverse(min_children)
    |> Enum.with_index
    |> Enum.map(fn({child, index}) -> {index, child} end)
    merge(%BHeap{trees: ranked_children}, %BHeap{trees: rest})
  end
end

defimpl Enumerable, for: Funpurr.Ch03.BinomialHeap do
  alias Funpurr.Ch03.BinomialHeap, as: BHeap
  def reduce(%BHeap{trees: t}, acc, reducer) do
    Enumerable.reduce(t, acc, reducer)
  end

  def count(%BHeap{trees: t}) do
    Enumerable.count(t)
  end

  def member?(%BHeap{trees: t}, term) do
    Enumerable.member?(t, term)
  end
end
