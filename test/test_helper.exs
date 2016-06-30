ExUnit.start()

defmodule MockHistory do
  defmacro num_calls({ {:., _, [ module , f ]} , _, args }) do
    quote do
      :meck.num_calls unquote(module), unquote(f), unquote(args)
    end
  end
end
