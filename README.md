# 为obs提供玲珑构建支持

这是一个用 python 编写的 obs 的 source service, 用于在构建玲珑之前处理源代码。

## 必要条件

需要在源码中包含 linglong.yaml 文件。

## 功能

### 使用git拉取源代码

玲珑支持在构建时从 git 拉取源代码，如：

```yaml
source:
  kind: git
  url: "https://github.com/linuxdeepin/linglong-builder-demo.git"
  commit: 24f78c8463d87ba12b0ac393ec56218240315a9
```

但 obs 是在离线环境运行构建的，这就需要将 linglong.yaml 文件中记录的 git 仓库提前下载，这个脚本会判断 source.kind 是否为 git ，如果是git，则使用 `git clone` 命令下载仓库，并打包成 `git_source.tar.zst` 文件。

### 生成deb文件

目前 obs 不支持玲珑仓库，所以需要将玲珑的构建结果再打包成 deb 格式，推送到 debian 仓库。这个脚本会读取 linglong.yaml 文件，获取包名、版本号、依赖项，并使用这些参数生成 deb 打包所需要的 control、postinst、postrm 文件，并生成一个打包脚本，在构建时通过打包脚本将生成的 deb 文件和构建结果一起打包成 deb 文件。

在构建脚本中也可实现 deb 文件生成和打包，但构建脚本是 sh 语言，不方便解析 yaml 文件，且构建脚本运行在虚拟机中，不便在外部查看生成的文件内容;
