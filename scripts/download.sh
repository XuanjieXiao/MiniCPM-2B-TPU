#!/bin/bash
res=$(which unzip)
if [ $? != 0 ]; then
    echo "Please install unzip on your system!"
    echo "Please run the following command: sudo apt-get install unzip"
    exit
fi
echo "unzip is installed in your system!"

pip3 install dfss -i https://pypi.tuna.tsinghua.edu.cn/simple --upgrade

scripts_dir=$(dirname $(readlink -f "$0"))
pushd $scripts_dir

# 检查 MiniCPM-2B-sft-bf16.zip 是否存在
if [ ! -f "MiniCPM-2B-sft-bf16.zip" ]; then
    python3 -m dfss --url=open@sophgo.com:sophon-demo/MiniCPM/MiniCPM-2B-sft-bf16.zip
fi

# 检查 bm1688_models.zip 是否存在
if [ ! -f "bm1688_models.zip" ]; then
    python3 -m dfss --url=open@sophgo.com:sophon-demo/MiniCPM/bm1688_models.zip
fi

# 检查 bm1684x_models.zip 是否存在
if [ ! -f "bm1684x_models.zip" ]; then
    python3 -m dfss --url=open@sophgo.com:sophon-demo/MiniCPM/bm1684x_models.zip
fi

if [ ! -d "../models" ]; then
    mkdir -p ../models
fi

unzip MiniCPM-2B-sft-bf16.zip -d ../compile/
if [ "$?" = "0" ]; then
  rm MiniCPM-2B-sft-bf16.zip
  echo "MiniCPM-2B-sft-bf16 Projects are ready"
else
  echo "MiniCPM-2B-sft-bf16 Projects unzip error"
fi

unzip bm1688_models.zip -d ../models/
if [ "$?" = "0" ]; then
  rm bm1688_models.zip
  echo "bm1688_models Models are ready"
else
  echo "bm1688_models Models unzip error"
fi

unzip bm1684x_models.zip -d ../models/
if [ "$?" = "0" ]; then
  rm bm1684x_models.zip
  echo "bm1684x_models Models are ready"
else
  echo "bm1684x_models Models unzip error"
fi
popd

