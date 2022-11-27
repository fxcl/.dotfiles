#!/bin/sh
# 给aria2 RPC添加一个下载完成通知 for macOS
# 最终效果：当下载完成会在屏幕右上角弹出一个提示框显示具体下载完成的文件名，
# 同时中文语音播报：“有个文件下载完成，请查收！”
# 变量 3 表示下载完成文件的路径
# 具体提示框设置可参考`https://code-maven.com/display-notification-from-the-mac-command-line`。
# 不支持设置自定义图标

fname=`basename $3`
osascript <<EOF
display notification "$fname 已经下载完成！" with title "【下载完成】"
say "有个文件下载完成，请查收！"
EOF
