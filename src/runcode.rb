require 'systemu'
require 'optparse'

=begin
EXTS = [
  '.cpp',
  '.cs',
  '.py',
  '.lua',
  '.go',
  '.hs',
  '.rb',
  '.scala',
]
=end

CommandMap = {
  '.cpp' => {
    :compile => 'g++ -std=c++11 %%',
    :execute => './a.out',
  },

  '.cs' => {
    :compile => 'mcs -debug %% -out:a.exe',
    :execute => 'mono --debug a.exe',
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
    parser.on('-q', '--quiet') {|v| args[:quiet] = v }
    parser.parse!(ARGV)
  end
  $quiet = args[:quiet]
  args
end

def latest_sourcefile
  # 更新日時の最も新しいソースファイルを取得する
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
    puts "# #{cmd}" unless $quiet
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
    puts "# #{cmd}" unless $quiet
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

  filename = nil
  if ARGV.size > 0
    filename = ARGV[0]
  else
    filename = latest_sourcefile()
  end

  if File.exists?(filename)
    compile(filename)
    execute(filename)
  else
    puts "file not found:#{filename}"
  end
end

if $0 == __FILE__
  main
end

