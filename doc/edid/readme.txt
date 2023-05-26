用 EEditZ 进行编辑
用 EDIDManager 查看和获取 VSDB offset
使用 6801 的 port 0
VSDB offset + 4 给 6801 的 0xc1
EEditZ 查看 CEA 的 第一个 VSDB 的 A B C D 值 ，一般是 1 0 0 0， 给 6801 的 0xc2 0xc3
从 EEditZ 工具生成的 校验值 给 6801 的 0xc4 0xc5


都可以用wine64执行 例如
alias wine='env LC_ALL="zh_CN.UTF-8" LANG="zh_CN.UTF-8" WINEARCH=win64 WINEPREFIX="/home/andreas/.wine-x64" wine'
