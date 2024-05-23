#!/bin/bash
res=$(which unzip)
if [ $? != 0 ]; then
    echo "Please install unzip on your system!"
    exit
fi
echo "unzip is installed in your system!"

pip3 install dfss -i https://pypi.tuna.tsinghua.edu.cn/simple --upgrade

scripts_dir=$(dirname $(readlink -f "$0"))
pushd $scripts_dir

python3 -m dfss --url=open@sophgo.com:sophon-demo/MiniCPM/MiniCPM-2B-sft-bf16.zip
python3 -m dfss --url=open@sophgo.com:sophon-demo/MiniCPM/bm1688_models.zip

if [ ! -d "../models" ]; then
    mkdir -p ../models
fi

if [ ! -d "../models/bm1688_models" ]; then
    mkdir -p ../models/bm1688_models
fi

if [ ! -d "../compile/MiniCPM-2B-sft-bf16" ]; then
    mkdir -p ../compile/MiniCPM-2B-sft-bf16
fi

unzip MiniCPM-2B-sft-bf16.zip -d ../compile/MiniCPM-2B-sft-bf16/
rm MiniCPM-2B-sft-bf16.zip

unzip bm1688_models.zip -d ../bm1688_models/
if [ "$?" = "0" ]; then
  rm bm1688_models.zip
  echo "Models are ready"
else
  echo "Models unzip error"
fi
popd

