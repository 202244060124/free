#!/bin/bash

output_file="output0.txt"
max_size=$((10 * 1024 * 1024))  # 10MB in bytes

# 从log.log中按行读取命令并执行
while IFS= read -r line || [[ -n "$line" ]]; do
    # 执行命令
    eval "$line"

    # 从README.md中提取最后的```到```中的内容，并去除代码块的标记
    sed -n '/```/,/```/p' README.md | sed '/```/d' >> "$output_file"

    # 检查当前输出文件的大小
    current_size=$(stat -c %s "$output_file")

    # 如果文件大小超过99MB, 则更换文件
    if (( current_size >= max_size )); then
        # 获取文件基本名和数字部分
        base=${output_file%%.txt}
        num=${base##output}
        num=$((num+1))

        # 创建新文件名
        output_file="output${num}.txt"
    fi
done < "log.log"