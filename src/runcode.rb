require 'systemu'
require 'optparse'

EXTS = ['.cpp', '.cs', '.py', '.lua', '.go', '.hs', '.rb']

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
  fs = Dir.glob('*').select {|f| EXTS.include?(File.extname(f)) }
  xs = fs.sort {|a, b| File.stat(a).mtime <=> File.stat(b).mtime }
  xs.last
end

def compile(filename)
  ext = File.extname(filename)

  command = nil
  case ext
  when '.cpp'
    command = "g++ -std=c++11 #{filename}"
  when '.cs'
    command = "mcs #{filename} -out:a.exe"
  when '.rb'
  end

  if command
    # コンパイルコマンド
    puts "# #{command}" unless $quiet
    _, stdout, stderr = systemu command
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
  ext = File.extname(filename)
  command = nil
  case ext
  when '.cpp'
    command = './a.out'
  when '.cs'
    command = 'mono a.exe'
  when '.rb'
    command = "ruby #{filename}"
  end

  if command
    # 実行コマンド
    puts "# #{command}" unless $quiet
    _, stdout, stderr = systemu command
    if !stdout.empty?
      puts stdout
    end
    if !stderr.empty?
      puts '----- STDERR -----'
      puts stderr
    end
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

