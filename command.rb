MARKER_FILENAME_WITHOUT_EXTENSION = '%filename-without-extension%'

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

  '.java' => {
    :compile => 'javac %%',
    :execute => "java #{MARKER_FILENAME_WITHOUT_EXTENSION}",
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

  '.py' => {
    :compile => nil,
    :execute => 'python3 %%',
  },

  '.rb' => {
    :compile => nil,
    :execute => 'ruby %%',
  },

  '.scala' => {
    :compile => nil,
    :execute => "scala -i %% -e 'Main.main(null)'",
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


