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

在开发板上或者X86主机执行如下编译：
您需要根据您使用的开发板及芯片种类进行选择

1、如果您是 `soc BM1688芯片` 请将参数设置为 `-DTARGET_ARCH=soc_bm1688`；

2、如果您是 `soc BM1684x芯片` 请将参数设置为 `-DTARGET_ARCH=soc_bm1684x`；

3、如果您是 `pcie BM1684x芯片` 请将参数设置为 `-DTARGET_ARCH=pcie`；

1. BM1684X PCIE环境下直接编译

当前路径/MiniCPM-2B/cpp

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

运行`minicpm`，如运行双核模型`minicpm-2b_int4_2core.bmodel`:

```shell
./minicpm --model ../../models/BM1688/minicpm-2b_int4_2core.bmodel --tokenizer ../token_config/tokenizer.model --devid 0
```
