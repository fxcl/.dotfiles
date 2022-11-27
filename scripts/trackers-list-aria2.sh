#!/bin/bash
#trackers-list-aria2.sh
# aria2 设置文件路径
CONF=${HOME}/.aria2/aria2.conf

#设置选择的 trackerlist （可选 all_aria2.txt, best_aria2.txt, http_aria2.txt）
trackerfile=all_aria2.txt
#downloadfile=https://raw.githubusercontent.com/ngosang/trackerslist/master/${trackerfile}
downloadfile=https://trackerslist.com/${trackerfile}

list=$(curl -fsSL ${downloadfile})
if ! grep -q "bt-tracker" "${CONF}" ; then
    echo -e "\033[34m==> 添加 bt-tracker 服务器信息......\033[0m"
    echo -e "\nbt-tracker=${list}" >> "${CONF}"
else
    echo -e "\033[34m==> 更新 bt-tracker 服务器信息.....\033[0m"
    sed -i '' "s@bt-tracker.*@bt-tracker=${list}@g" "${CONF}"
fi

## 重启 aria2 服务
echo -e "\033[34m==> 停止 aria2 服务......\033[0m"
launchctl stop aria2
echo -e "\033[34m==> 启动 aria2 服务......\033[0m"
launchctl start aria2
