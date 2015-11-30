require 'systemu'
require 'optparse'

CommandMap = {
  '.cpp' => {
    :compile => 'g++ -std=c++11 %%',
    :execute => './a.out',
  },

  '.cs' => {
    :compile => 'mcs -checked+ -r:System.Numerics -debug %% -out:a.exe',
    :execute => 'mono --debug a.exe',
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
    :execute => 'scala %%',
  },

}

def parse_args
  args = {}
  OptionParser.new do |parser|
    # コマンドを出力しない
    parser.on('-q', '--quiet')   {|v| args[:quiet] = v }
    parser.on('-c', '--compile') {|v| args[:only_compile] = v }
    parser.parse!(ARGV)
  end
  $quiet = args[:quiet]
  $only_compile = args[:only_compile]
  args
end

# 更新日時の最も新しいソースファイルを取得する
def find_newest_filename
  exts = CommandMap.keys
  fs = Dir.glob('*').select {|f| exts.include?(File.extname(f)) }
  xs = fs.sort {|a, b| File.stat(a).mtime <=> File.stat(b).mtime }
  xs.last
end

def get_compile_command(filename)
  ext = File.extname(filename)
  m = CommandMap[ext]
  cmd = m[:compile]
  if cmd
    cmd = cmd.sub('%%', filename)
  end
  cmd
end

def get_execute_command(filename)
  ext = File.extname(filename)

  m = CommandMap[ext]
  cmd = m[:execute]
  if cmd
    cmd = cmd.sub('%%', filename)
  end
  cmd
end

def compile(filename)
  cmd = get_compile_command(filename)
  if cmd
    # コンパイルコマンド
    STDERR.puts "# #{cmd}" unless $quiet
    _, stdout, stderr = systemu cmd
    if !stdout.empty?
      puts stdout
    end
    if !stderr.empty?
      puts stderr
      exit
    end
  end
end

def execute(filename)
  cmd = get_execute_command(filename)
  if cmd
    # 実行コマンド
    STDERR.puts "# #{cmd}" unless $quiet
    system("#{cmd}")
=begin
    # 問題点:
    # stdout を受け取る形にすると、無限ループに入るような
    # プログラムだと途中の出力が見られない。

    _, stdout, stderr = systemu command
    if !stdout.empty?
      puts stdout
    end
    if !stderr.empty?
      puts '----- STDERR -----'
      puts stderr
    end
=end

  end
end

def main
  _ = parse_args()

  filename = find_newest_filename()
  if filename.nil?
    puts "target file not found"
    exit
  end

  if File.exists?(filename)
    compile(filename)
    execute(filename) unless $only_compile
  else
    puts "file not found:#{filename}"
  end
end

if $0 == __FILE__
  main
end

