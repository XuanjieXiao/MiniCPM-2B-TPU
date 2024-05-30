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

# 检查 BM1688.zip 是否存在
if [ ! -f "BM1688.zip" ]; then
    python3 -m dfss --url=open@sophgo.com:sophon-demo/MiniCPM/BM1688.zip
fi

# 检查 BM1684X.zip 是否存在
if [ ! -f "BM1684X.zip" ]; then
    python3 -m dfss --url=open@sophgo.com:sophon-demo/MiniCPM/BM1684X.zip
fi

# 检查 lib_pcie.zip 是否存在
if [ ! -f "lib_pcie.zip" ]; then
    python3 -m dfss --url=open@sophgo.com:sophon-demo/MiniCPM/lib_pcie.zip
fi

# 检查 lib_soc_bm1684x.zip 是否存在
if [ ! -f "lib_soc_bm1684x.zip" ]; then
    python3 -m dfss --url=open@sophgo.com:sophon-demo/MiniCPM/lib_soc_bm1684x.zip
fi

# 检查 lib_soc_bm1688.zip 是否存在
if [ ! -f "lib_soc_bm1688.zip" ]; then
    python3 -m dfss --url=open@sophgo.com:sophon-demo/MiniCPM/lib_soc_bm1688.zip
fi

# 检查 token_config.zip 是否存在
if [ ! -f "token_config.zip" ]; then
    python3 -m dfss --url=open@sophgo.com:sophon-demo/MiniCPM/token_config.zip
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

unzip BM1688.zip -d ../models/
if [ "$?" = "0" ]; then
  rm BM1688.zip
  echo "BM1688 Models are ready"
else
  echo "BM1688 Models unzip error"
fi

unzip BM1684X.zip -d ../models/
if [ "$?" = "0" ]; then
  rm BM1684X.zip
  echo "BM1684X Models are ready"
else
  echo "BM1684X Models unzip error"
fi

unzip lib_pcie.zip -d ../cpp/
if [ "$?" = "0" ]; then
  rm lib_pcie.zip
  echo "lib_pcie  are ready"
else
  echo "lib_pcie  unzip error"
fi

unzip lib_soc_bm1684x.zip -d ../cpp/
if [ "$?" = "0" ]; then
  rm lib_soc_bm1684x.zip
  echo "lib_soc_bm1684x  are ready"
else
  echo "lib_soc_bm1684x  unzip error"
fi

unzip lib_soc_bm1688.zip -d ../cpp/
if [ "$?" = "0" ]; then
  rm lib_soc_bm1688.zip
  echo "lib_soc_bm1688  are ready"
else
  echo "lib_soc_bm1688  unzip error"
fi

unzip token_config.zip -d ../cpp/
if [ "$?" = "0" ]; then
  rm token_config.zip
  echo "token_config  are ready"
else
  echo "token_config  unzip error"
fi

popd

