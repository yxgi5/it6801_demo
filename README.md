# 717 vs 717F
717比717F牛逼一些，可以6Gbps，717F只有3Gbps


# block design

[doc/system.pdf](doc/system.pdf)

[doc/xgpio_i2c_0.pdf](doc/xgpio_i2c_0.pdf)


# clocking

tx:
```
aixs_clk*bpp*ppc>=lane_rate*lane_num>=width*hight*fps*bpp
aixs_clk1>=width*hight*fps/ppc, 这里最好用带消隐的w和h
lane_rate>=width*hight*fps*bpp/lane_num
aixs_clk2>=lane_rate*lane_num/(bpp*ppc)=width*hight*fps/ppc
lane_rate<=aixs_clk*bpp*ppc/lane_num
```

```
3840x2160@30_RAW12_1ppc_4lane
aixs_clk1>=4400*2250*30/1=297MHz
lane_rate>=3840*2160*30*12/4=746496000~=750MHz
aixs_clk2>=3840*2160*30/1=248832000~=250MHz
use aixs_clk==300M, lane_rate<=aixs_clk*bpp*ppc/lane_num=300x12x1/4=900(MHz)
lane_rate use 800MHz

1920x1080@30_UYVY-8_1ppc_4lane
aixs_clk1>=2200*1125*30/1=74.25MHz
lane_rate>=1920*1080*30*16/4=248832000~=250MHz
aixs_clk2>=1920*1080*30/1=62208000
use aixs_clk==300M, lane_rate<=aixs_clk*bpp*ppc/lane_num=300x16x1/4=1200(MHz)
```

rx:
```
width*hight*fps*bpp<=lane_rate*lane_num<=aixs_clk*bpp*ppc
lane_rate>=width*hight*fps*bpp/lane_num
aixs_clk>=lane_rate*lane_num/(bpp*ppc)>=width*hight*fps/ppc
lane_rate<=aixs_clk*bpp*ppc/lane_num
```

```
3840x2160@30_RAW12_1ppc_4lane
lane_rate>=3840*2160*30*12/4=746496000~=750MHz
when lane_rate==800MHz
aixs_clk>=800*4/12/1=266.6MHz>=3840*2160*30/1=248832000~=250MHz, use 300M

1920x1080@30_UYVY-8_1ppc_4lane
lane_rate>=1920*1080*30*16/4=248832000~=250MHz
when lane_rate==1200MHz
aixs_clk>=1200*4/16/1=300>=1920*1080*30/1=62208000
```


# 资源略超
vivado tcl命令行输入
```
set_param drc.disableLUTOverUtilError 1
```
如果默认优化后装得下，就ok; 如果默认优化还是装不下，生成bitstream会失败。



