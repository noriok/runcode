## 簡易プログラム実行

ファイルの拡張子に応じて、コンパイル、および実行コマンドを実行します。

## サンプル

```
% cat hello.rb
puts 'hello'
% runcode hello.rb
# ruby hello.rb
hello
% cat hello.cpp
#include <cstdio>

int main() {
    puts("hello");
}
% runcode hello.cpp
# g++ -std=c++11 hello.cpp
# ./a.out
hello
```

`runcode` を引数なしで実行すると、カレントディレクトリにあるファイルの最終更新時刻の最も新しいファイルが適用されます。

