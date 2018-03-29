defmodule Snitch.Profiler do
  defmacro profile(do: block) do
    quote do
      Mix.Tasks.Profile.Fprof.profile(fn -> unquote(block) end,
        warmup: false, sort: "own", callers: true)
    end
  end
end