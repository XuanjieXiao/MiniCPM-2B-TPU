# 环境准备
```
pip3 install dfss
```

如果不打算自己编译模型，可以直接用下载好的模型
```
python3 -m dfss --url=open@sophgo.com:sophon-demo/MiniCPM/bm1688_models.zip
unzip bm1688_models.zip
```

编译库文件
```
cd demo
mkdir build
cd build
cmake -DTARGET_ARCH=soc_bm1688 ..
make
```

# cpp demo
```
./minicpm --model ../../models/minicpm-2b_int4_2core.bmodel --tokenizer ../../support/token_config/tokenizer.model  --devid 0
```
