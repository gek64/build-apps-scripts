#!/bin/bash

Toolbox=("go")
OS=("windows" "linux" "darwin" "freebsd" "netbsd" "openbsd" "dragonfly" "android" "openwrt")
Architecture=("amd64" "386" "arm" "arm64" "mips64le" "mips64" "mipsle" "mips" "riscv64")

SpecifiedOS=""
SpecifiedArch=""
Proxy=""
ProgramName=""
BuildAll=false

BaseFolder=$(go mod graph | awk '{print $1}')

# 检查工具链
function CheckToolbox() {
  pass=true
  for i in "${Toolbox[@]}"; do
    if [ ! "$(command -v "$i")" ]; then
      echo -e "\033[31m找不到$i\033[0m"
      pass=false
    fi
  done

  ## 返回值判断
  if $pass; then
    return 0
  else
    echo -e "\033[31m未能满足运行条件,请安装以上依赖后再启动程序\033[0m"
    return 1
  fi
}

# 获取程序名称
function GetProgramName() {
  if [ "$ProgramName" == "" ]; then
    ProgramName="$BaseFolder"
  fi
}

# 显示帮助信息
function Show_help() {
  cat <<-EOF
    Usage:
    $0 [Arguments]

    Arguments:
      -p | --proxy proxy_url      : use proxy
      -n | --name  staticName     : set static file name (only work when use --all or --os --arch)
      -h | --help                 : show help
      --all                       : build all supported OS and architecture
      --os OS --arch Architecture : specify OS and architecture

    Example:
      1) $0 -p http://127.0.0.1:1080
      2) $0 -n myapp
      2) $0 --all
      4) $0 --os windows --arch amd64
      5) $0 -h

    More Information:
      1) Please visit https://golang.org/doc/install/source#environment for more information on supported operating system and architecture pairs
      2) You may need to install gcc to build some special os and arch pairs,such as android/386 and android/amd64 and android/arm

EOF
  exit 0
}

# 初始化,解析传入参数
function Init() {
  # 检查依赖库是否安装
  if ! CheckToolbox; then
    exit 1
  fi
  # 获取编译文件名
  GetProgramName
  # 获取Args
  while [[ $# -gt 0 ]]; do
    case "$1" in
    "-h" | "--help")
      Show_help
      break
      ;;
    "-n" | "--name")
      ProgramName=$2
      shift
      ;;
    "-p" | "--proxy")
      Proxy=$2
      shift
      ;;
    "--os")
      SpecifiedOS=$2
      shift
      ;;
    "--arch")
      SpecifiedArch=$2
      shift
      ;;
    "--all")
      BuildAll=true
      shift
      ;;
    *)
      echo "$0: Unknown Arguments"
      Show_help
      exit 1
      ;;
    esac
    shift
  done

  # 检查OS与Arch是否同时指定
  if [ "$SpecifiedOS" == "" ] && [ "$SpecifiedArch" != "" ]; then
    echo -e "\033[31m指定了Arch=$SpecifiedArch,OS未指定\033[0m"
    exit 1
  elif [ "$SpecifiedOS" != "" ] && [ "$SpecifiedArch" == "" ]; then
    echo -e "\033[31m制定了OS=$SpecifiedOS,Arch未指定\033[0m"
    exit 1
  fi

}

# 编译
function Build() {
  # 设置Proxy
  if [ "$Proxy" != "" ]; then
    export http_proxy=$Proxy
    export https_proxy=$Proxy
  fi

  # 编译指定系统与指定架构
  if [ "$SpecifiedOS" != "" ] && [ "$SpecifiedArch" != "" ]; then
    export "GOOS=$SpecifiedOS"
    export "GOARCH=$SpecifiedArch"

    # windows
    if [ "$SpecifiedOS" == "windows" ]; then
      staticFile="bin/$ProgramName-$SpecifiedOS-$SpecifiedArch.exe"
    else
      staticFile="bin/$ProgramName-$SpecifiedOS-$SpecifiedArch"
    fi

    # openwrt mips
    if [ "$SpecifiedOS" == "openwrt" ]; then
      if [ "$SpecifiedArch" == "mips64le" ] || [ "$SpecifiedArch" == "mips64" ] || [ "$SpecifiedArch" == "mipsle" ] || [ "$SpecifiedArch" == "mips" ]; then
        export "GOOS=linux"
        export "GOMIPS=softfloat"
      fi
    fi

    go build -v -trimpath -ldflags "-s -w" -o "$staticFile"
    return 0
  fi

  # 编译全部预设的系统与架构
  if $BuildAll; then
    for i in "${OS[@]}"; do
      for j in "${Architecture[@]}"; do
        export "GOOS=$i"
        export "GOARCH=$j"

        # windows
        if [ "$i" == "windows" ]; then
          staticFile="bin/$ProgramName-$i-$j.exe"
        else
          staticFile="bin/$ProgramName-$i-$j"
        fi

        # openwrt mips
        if [ "$i" == "openwrt" ]; then
          if [ "$j" == "mips64le" ] || [ "$j" == "mips64" ] || [ "$j" == "mipsle" ] || [ "$j" == "mips" ]; then
            export "GOOS=linux"
            export "GOMIPS=softfloat"
          fi
        fi

        go build -v -trimpath -ldflags "-s -w" -o "$staticFile"
      done
    done
    return 0
  fi

  # 编译当前系统与架构
  go build -v -trimpath -ldflags "-s -w"
  return 0
}

Init "$@"
Build
