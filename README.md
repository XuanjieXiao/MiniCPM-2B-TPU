# MiniCPM

## 目录
- [MiniCPM](#minicpm)
  - [目录](#目录)
  - [1. 简介](#1-简介)
  - [2. 运行环境准备](#2-运行环境准备)
    - [2.1 环境部署问题](#21-环境部署问题)
  - [3. 准备模型](#3-准备模型)
    - [3.1 使用提供的模型](#31-使用提供的模型)
    - [3.2 开发环境准备](#32-开发环境准备)
    - [3.3 编译模型(分布式)](#33-编译模型分布式)
  - [4. C++例程](#4-C++例程)

## 1. 简介
MiniCPM 是面壁与清华大学自然语言处理实验室共同开源的系列端侧语言大模型，主体语言模型 MiniCPM-2B 仅有 24亿（2.4B）的非词嵌入参数量。

该例程提供了C++版本，支持BM1688芯片和BM1684X芯片，支持在插有1684X系列加速卡的x86主机上运行，也可以SE9和SE7上运行。

1、对于1684X芯片，支持在(libsophon_0.5.0)及以上的SDK上运行；

2、对于1688芯片，支持在libsophon0.4.9及以上的SDK上运行。

其中在SE7上运行需要额外进行环境配置，请参照[运行环境准备](#2-运行环境准备)完成环境部署。


## 2. 运行环境准备
以下为soc模式相关：

### 2.1 环境部署问题
您可能会遇到有报错，请参考[FAQ](./docs/FAQ.md)


## 3. 准备模型
该模型目前支持在BM1688和BM1684X上运行，已提供编译好的bmodel。

### 3.1 使用提供的模型

​本例程在`scripts`目录下提供了相关模型载脚本`download.sh`

```bash
# 安装unzip，若已安装请跳过，非ubuntu系统视情况使用yum或其他方式安装
sudo apt-get update
sudo apt install unzip
chmod -R +x scripts/
./scripts/download.sh
```
 
执行程序后，当前目录下的文件如下：

```
.
├── assets                              #图片文件
│   ├── image.png
│   ├── Show_Results.png
│   └── sophgo_chip.png
├── compile                             #模型编译文件
│   ├── compile_bm1684x.sh              #编译1684X的脚本
│   ├── compile_bm1688.sh               #编译1688的脚本
│   ├── export_onnx.py                  #导出onnx模型脚本
│   └── files                           
│       └── minicpm-2b                  
│           └── modeling_minicpm.py     #模型文件
├── demo        
│   ├── CMakeLists.txt                  
│   ├── demo.cpp                        #主程序
│   └── README.md                       #例程说明
├── docs               
│   └── FAQ.md                          #问题汇总
├── README.md                           #使用说明
├── requirements.txt                    #需求库
├── scripts                             #下载脚本等
└── support                             #编译所需头文件及链接库
    ├── include_bm1684x
    ├── include_bm1688
    ├── lib_pcie
    ├── lib_soc_bm1684x
    ├── lib_soc_bm1688
    └── token_config
```
 
**注意：**在下载模型前，应该保证存储空间大于25GB。

### 3.2 开发环境准备
编译模型需要在x86主机完成。

**注意：** MiniCPM-2B官方库10G左右，转模型需要保证运行内存至少40G以上，导出onnx模型需要存储空间60G以上。

模型编译的详细信息可以参考[MiniCPM-2B-TPU](https://github.com/XuanjieXiao/MiniCPM-2B-TPU.git)。
以下是基本步骤：

1. 下载docker，启动容器

```bash
docker pull sophgo/tpuc_dev:latest
# myname1234 is just an example, you can set your own name
docker run --privileged --name myname1234 -v $PWD:/workspace -it sophgo/tpuc_dev:latest
```

当前$PWD应该是sophon-demo/sample/MiniCPM

后文(模型转换过程)假定环境都在docker的/workspace目录。

2. 下载MiniCPM-2B

您可以使用方法一，从Huggingface下载`MiniCPM-2B`，比较大，会花较长时间。同时，我们也为您提供了便捷的下载方式，您可以使用下面方法二来下载：

方法一：
``` shell
git lfs install
git clone git@hf.co:openbmb/MiniCPM-2B-sft-bf16
```

方法二：
``` shell
pip3 install dfss
sudo apt-get update
sudo apt-get install unzip
python3 -m dfss --url=open@sophgo.com:sophon-demo/MiniCPM/MiniCPM-2B-sft-bf16.zip
unzip MiniCPM-2B-sft-bf16.zip
```

将解压后的文件放至/compile路径下

并对该工程做如下修改：

使用`files/minicpm-2b`下的`modeling_minicpm.py`替换在 `MiniCPM-2B-sft-bf16` 目录下的原模型的对应文件`modeling_minicpm.py`

3. 下载`TPU-MLIR`代码并编译，(也可以直接下载编译好的release包解压)

``` shell
git clone git@github.com:sophgo/tpu-mlir.git
cd tpu-mlir
source ./envsetup.sh
./build.sh
```

4. 下载[sentencepiece](https://github.com/google/sentencepiece)，并编译得到`sentencepiece.a`(sentencepiece已集成在tools目录下)

```shell
git clone git@github.com:google/sentencepiece.git
cd sentencepiece
mkdir build
cd build
cmake ..
make -j
```

如果要编译SoC环境，则需要在cpp的`CMakeLists.txt`加入如下代码：

```cmake
set(CMAKE_C_COMPILER aarch64-linux-gnu-gcc)
set(CMAKE_ASM_COMPILER aarch64-linux-gnu-gcc)
set(CMAKE_CXX_COMPILER aarch64-linux-gnu-g++)
```
(如果需要重新编译sentencepiece,也需要在sentencepiece的`CMakeLists.txt`进行上述修改)

5. 下载libsophon库并安装

在算能官网<https://developer.sophgo.com/site/index/material/all/all.html>可以找到SDK最新版本，如下：

```shell
wget https://sophon-file.sophon.cn/sophon-prod-s3/drive/23/06/15/16/Release_230501-public.zip
```
解压sdk后安装libsophon，如下：

```shell
apt install sophon-libsophon-dev_0.4.8_amd64.deb
```

注意如果是SoC环境则安装arm64版本`sophon-libsophon-dev_0.4.8_arm64.deb`

### 3.3 编译模型(分布式)

分布式编译出来的模型在单芯和多芯上均可使用
(在编译前请先在`TPU-MLIR`中执行)

```shell
source ./envsetup.sh
./build.sh
```

1. 导出所有onnx模型，如果过程中提示缺少某些组件，直接pip install 组件即可

```bash
cd scripts/compile
python3 export_onnx.py
```
此时有大量onnx模型被导出到compile/tmp目录。

2. 对onnx模型进行编译，生成bmodel，这个过程会花一些时间，最终生成`minicpm-7b.bmodel`文件　
```shell
./compile --num_device 1 --mode int8
```
其中num_device决定了后续所需要使用的推理芯片的数量(SOC请使用1), mode目前支持
"int4"(scripts/download.sh 中提供已经转好的bmodel),
"int8"(scripts/download.sh 中提供已经转好的bmodel),
"f16"(不提供已经转好的bmodel，编译模型和推理时num_device至少为2),
提供的模型文件均可以在执行scripts/download.sh 中下载

## 4. C++例程
C++例程请参考[C++例程](./cpp/README.md)
