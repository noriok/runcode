require 'systemu'
require 'optparse'

require_relative './command'

module Runcode
  module_function

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

  def get_command(command_type, filename)
    ext = File.extname(filename)

    cmd = CommandMap[ext][command_type]
    if cmd
      filename_without_extension = File.basename(filename, ".*")

      cmd = cmd.sub('%%', filename)
      cmd = cmd.sub(MARKER_FILENAME_WITHOUT_EXTENSION, filename_without_extension)
    end
    cmd
  end

  def compile(filename)
    cmd = get_command(:compile, filename)
    if cmd
      # コンパイルコマンド
      STDERR.puts "# #{cmd}" unless $quiet
      _, stdout, stderr = systemu cmd
      if !stdout.empty?
        puts stdout
      end
      if !stderr.empty?
        puts stderr
        exit(1)
      end
    end
  end

  def execute(filename)
    cmd = get_command(:execute, filename)
    if cmd
      STDERR.puts "# #{cmd}" unless $quiet
      system("#{cmd}")
    end
  end

  def execute2(filename, input)
    cmd = get_command(:execute, filename)
    if cmd
      status, stdout, stderr = systemu cmd, 0=>input
      return status, stdout, stderr
    end
  end

  def main
    parse_args()

    filename = find_newest_filename()
    if filename.nil? || !File.exist?(filename)
      puts "target file not found"
      exit
    end

    compile(filename)
    execute(filename) unless $only_compile
  end
end

if $0 == __FILE__
  Runcode::main
end

