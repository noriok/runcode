require 'systemu'
require 'pathname'
require 'yaml'

module Runcode
  module_function

  # 実行するファイルとコマンドを返す
  def find_execute_target(cmds)
    fs = Dir.glob('*').select {|f| cmds.include?(File.extname(f)) }
    filename = fs.max_by {|f| File.stat(f).mtime }
    return filename, cmds[File.extname(filename)]
  end

  def load_yaml
    path = Pathname(File.dirname(__FILE__)).join('command.yaml').to_path
    YAML.load_file(path)
  end

  def run()
    cmds = load_yaml()
    filename, cmd = find_execute_target(cmds)

    if filename.nil?
      STDERR.puts 'execute file not found'
      exit
    end

    # 実行
    if cmd.include?('execute')
      execute_cmd = cmd['execute'].sub('%%', filename)
      STDERR.puts "# #{execute_cmd}"
      system("#{execute_cmd}")
    end
  end

  def execute_with_input(filename, input)
    cmds = load_yaml()
    unless cmds.include?(File.extname(filename))
      puts "command not found: #{filename}"
      exit
    end

    execute_cmd = cmds[File.extname(filename)]['execute'].sub('%%', filename)
    status, stdout, stderr = systemu execute_cmd, 0=>input
    return status, stdout, stderr
  end

  def main
    run()
  end
end

if $0 == __FILE__
  Runcode::main
end

