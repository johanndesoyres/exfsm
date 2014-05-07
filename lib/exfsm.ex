defmodule ExFSM do
  # @on_definition { ExFSMdef, :on_def }

  defmacro __before_compile__(_env) do
    quote do
      def desc, do: @desc 
    end
  end

  defmacro __using__(_opts) do
    quote do
      import ExFSM
      @desc HashDict.new()
      @before_compile ExFSM
    end
  end

  defmacro defsfm(head, body) do
    str   = Macro.to_string(head)
    [_,fname,fargs] =  Regex.run(~r/(.*?)\((.*?)\)/, str)
    quote do     
      @desc Dict.put(@desc,unquote(fname),[unquote(fargs)
                                           |Dict.get(@desc,unquote(fname),[])])
      def unquote(head), unquote(body)
      def unquote(binary_to_atom(fname<>"_desc"))(), do: unquote(str)
    end  
  end

end

