require 'systemu'

# EXTS = ['.cpp', '.cs', '.rb', '.py', '.lua', '.go', '.hs']
EXTS = ['.cpp', '.cs', '.py', '.lua', '.go', '.hs']

def latest_sorucefile
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
    puts "compile:#{command}"
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

def run(filename)
  ext = File.extname(filename)
  command = nil
  case ext
  when '.cpp'
    command = './a.out'
  when '.cs'
    command = 'mono a.exe'
  when '.rb'
    _, stdout, _ = systemu "ruby #{filename}"
    puts stdout
  end

  if command
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
  filename = latest_sorucefile()

  compile(filename)
  run(filename)
end

if $0 == __FILE__
  main
end

