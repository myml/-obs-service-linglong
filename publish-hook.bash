#!/bin/bash -e
deb_server="http://x.x.x.x"
deb_project="linglong-repo"
deb_repo="linglong-base_Deepin_23"
deb_package="linglong.bzip2_1.0.6_amd64.deb"

ll_repo="/tmp/linglong-publish/repo"

# 初始化玲珑仓库
mkdir -p $ll_repo/$deb_project
ostree init --repo=$ll_repo/$deb_project --mode=bare-user-only

# 多个玲珑仓库共用上层objects目录
mkdir -p $ll_repo/objects
rm -r $ll_repo/$deb_project/objects
ln -s $ll_repo/objects $ll_repo/$deb_project/

# 创建临时目录
tmpDir=`mktemp -d`
cd $tmpDir
# 下载deb包文件
wget $deb_server/$deb_project/$deb_repo/amd64/$deb_package
# 解压deb包文件
dpkg-deb -R $deb_package $tmpDir
# 设置环境变量
export LINGLONG_REPO_DIR=$ll_repo/$deb_project
export LINGLONG_DEB_DIR=$tmpDir/var/cache/linglong/deb
# 执行安装脚本
$tmpDir/DEBIAN/postinst

# 清理临时文件
rm -r $tmpDir
