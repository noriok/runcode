CommandMap = {
  '.cpp' => {
    :compile => 'g++ -std=c++11 %%',
    :execute => './a.out',
  },

  '.cs' => {
    # :compile => 'mcs -checked+ -r:System.Numerics -debug %% -out:a.exe',
    # :execute => 'mono --debug a.exe',
    :compile => 'csc /checked /out:a.exe /nologo %%',
    :execute => 'mono a.exe',
  },

  '.d' => {
      :compile => nil,
      :execute => 'rdmd %%',
  },

  '.go' => {
    :compile => nil,
    :execute => 'go run %%',
  },

  '.hs' => {
    :compile => nil,
    :execute => 'runhaskell %%',
  },

  '.hx' => {
    :compile => 'haxe -main %% -neko Main.n',
    :execute => 'neko Main.n',
  },

  '.jl' => {
    :compile => nil,
    :execute => 'julia %%',
  },

  '.js' => {
    :compile => nil,
    :execute => 'node %%',
  },

  '.kt' => {
      :compile => 'kotlinc %% -include-runtime -d main.jar',
      :execute => 'java -jar main.jar'
  },

  '.kts' => {
      :compile => nil,
      :execute => 'kotlinc -script %%'
  },

  '.lua' => {
    :compile => nil,
    :execute => 'lua %%',
  },

  '.php' => {
      :compile => nil,
      :execute => 'php %%',
  },

  '.py' => {
    :compile => nil,
    :execute => 'python3 %%',
  },

  '.rb' => {
    :compile => nil,
    :execute => 'ruby %%',
  },

  '.scm' => {
    :compile => nil,
    :execute => "gosh %%",
  },

  '.swift' => {
    :compile => nil,
    :execute => "swift %%",
  },
}


