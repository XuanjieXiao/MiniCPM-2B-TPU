# MiniCPM-2B C++例程

## 目录
- [MiniCPM-2B C++例程](#MiniCPM-2B-C++例程)
  - [目录](#目录)
  - [1. 编译程序](#1-编译程序)
  - [2. 例程测试](#2-例程测试)


## 1. 编译程序
PCIE环境下直接编译可以在之前使用的tpu的docker下继续执行；SOC环境下也可以直接编译即可。

如果在使用或者测试过程中遇到问题，可以先参考[常见问题说明](../docs/FAQ.md)

进行编译之前，请先确认之前已经执行过`MiniCPM-2B/scripts/download.sh`

1. BM1684X PCIE环境下直接编译

当前路径/MiniCPM-2B/demo

```shell
mkdir build
cd build
cmake -DTARGET_ARCH=pcie ..
make -j
```
 
2. BM1684X SOC环境下直接编译
```shell
mkdir build
cd build
cmake -DTARGET_ARCH=soc_bm1684x ..
make -j
```

3. BM1688 SOC环境下直接编译
```shell
mkdir build
cd build
cmake -DTARGET_ARCH=soc_bm1688 ..
make -j
```

## 2. 例程测试
在编译完成后，会根据pcie或soc模式在项目路径下生成minicpm的可执行文件, tokenizer、bmodel路径以及chip id都可以可以通过下列参数来指定,设置好以后即可运行

单芯(pcie和soc均支持, 以soc为例)
```shell
./minicpm.soc --model your_bmodel_name --tokenizer your tokenizer.model path --devid your devid
```