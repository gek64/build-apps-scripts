#!/bin/bash

Toolbox=("apt" "cat")

# 显示帮助信息
function Show_help() {
  cat <<-EOF
 ▄▄▄▄▄▄ ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄    ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄ ▄▄▄
█      █       █       █  █       █       █   █
█  ▄   █    ▄  █▄     ▄█  █       █▄     ▄█   █
█ █▄█  █   █▄█ █ █   █    █     ▄▄█ █   █ █   █
█      █    ▄▄▄█ █   █    █    █    █   █ █   █▄▄▄
█  ▄   █   █     █   █    █    █▄▄  █   █ █       █
█▄█ █▄▄█▄▄▄█     █▄▄▄█    █▄▄▄▄▄▄▄█ █▄▄▄█ █▄▄▄▄▄▄▄█
Version:
  1.00

Usage:
  $0 [Command]

Command:
  -h  | --help      : show help
  -v  | --version   : show version

Example:
  1) $0
  2) $0 -h
  3) $0 -v

EOF
  exit 0
}

# 显示changelog
function Show_changelog() {
  cat <<-EOF
 ▄▄▄▄▄▄ ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄    ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄ ▄▄▄
█      █       █       █  █       █       █   █
█  ▄   █    ▄  █▄     ▄█  █       █▄     ▄█   █
█ █▄█  █   █▄█ █ █   █    █     ▄▄█ █   █ █   █
█      █    ▄▄▄█ █   █    █    █    █   █ █   █▄▄▄
█  ▄   █   █     █   █    █    █▄▄  █   █ █       █
█▄█ █▄▄█▄▄▄█     █▄▄▄█    █▄▄▄▄▄▄▄█ █▄▄▄█ █▄▄▄▄▄▄▄█
Changelog:
  1.00:
    - First release

EOF
  exit 0
}

# 初始化配置
function Init() {
  # 检查是否root运行
  if ! CheckRoot; then
    exit 1
  fi

  # 检查依赖库是否安装
  if ! CheckToolbox; then
    exit 1
  fi

  # 没带参数直接运行
  if [ $# == 0 ]; then
    run
    exit 0
  fi

  while [[ $# -gt 0 ]]; do
    case "$1" in
    "-h" | "--help")
      Show_help
      break
      ;;
    "-v" | "--version")
      Show_changelog
      break
      ;;
    *)
      echo "$0: Unknown Arguments"
      Show_help
      exit 1
      ;;
    esac
    shift
  done
}

# 检查工具链
function CheckToolbox() {
  local pass=true
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

# 检查是否使用root权限
function CheckRoot() {
  if [ "$EUID" != 0 ]; then
    echo "Please run as root"
    return 1
  fi
  return 0
}

function Upgrade() {
  apt update
  apt upgrade -y
  apt full-upgrade -y
}

function Clean() {
  apt --purge autoremove -y
  apt clean
  apt autoclean
}

function run() {
  # 检查是否root运行
  if ! CheckRoot; then
    exit 1
  fi
  Upgrade
  Clean
}

Init "$@"
