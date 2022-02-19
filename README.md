# Backbone-Runtime
This repository provides code for initializing, testing, and measuring the running time of neural networks on Apple devices.

<br/>

## Device
Measurements were taken using the **Iphone 8 emulator on a MacBook Air (2020) M1 8GB**.
**OS: Monterey 12.1**.

<br/>

## Inference
During testing were open: Safari, Xcode (=> Emulator) and Terminal.

Time was measured for each model individually (i.e. there was only one model in the "models" folder).

<br/>

## Сonfiguration
The models were initialized using [timm](https://github.com/rwightman/pytorch-image-models). MobileViT have been initialized in the [cvnets repo](https://github.com/apple/ml-cvnets/blob/main/main_conversion.py#L26).

The models have normalization and taking the top 5 probabilities. The models were converted using [coremltools](https://github.com/apple/coremltools). More: [ipynb](Create%20models.ipynb).

<br/>

## Benchmark
| Architecture family |  Model name          | MLmodel weight, MB | Running time (100 starts) on emulator Iphone 8, sec |        |        | Average frames / sec | Metrics        |                | Interpolation |
| ------------------- | -------------------- | ------------------ | --------------------------------------------------- | ------ | ------ | -------------------- | -------------- | -------------- | ------------- |
|                     |                      |                    | Min                                                 | Max    | Avg    |                      | ImageNet top-1 | ImageNet top-5 |               |
| MobileNet           | mn2_100              | 14,7               | 0,0090                                              | 0,0114 | 0,0100 | 99,86482083          | 72,952         | 91,002         | bicubic       |
|                     | mn2_110d             | 18                 | 0,0128                                              | 0,0152 | 0,0137 | 72,92339643          | 75,052         | 92,188         | bicubic       |
|                     | mn3_rw               | 21,9               | 0,0078                                              | 0,0098 | 0,0087 | 115,1641272          | 75,63          | 92,708         | bicubic       |
|                     | mn3_large_100_miil   | 21,9               | 0,0074                                              | 0,0090 | 0,0084 | 118,5257193          | 77,918         | 92,906         | bicubic       |
| Gernet              | gernet_s             | 32,6               | 0,0111                                              | 0,0188 | 0,0125 | 79,71578839          | 76,912         | 93,134         | bilinear      |
|                     | gernet_m             | 84,4               | 0,0293                                              | 0,0397 | 0,0309 | 32,32946595          | 80,746         | 95,184         | bilinear      |
| Pit                 | pit_xs_224           | 49,5               | 0,0469                                              | 0,0520 | 0,0495 | 20,21368422          | 78,188         | 94,166         | bicubic       |
|                     | pit_xs_distilled_224 | 44                 | 0,0464                                              | 0,0514 | 0,0493 | 20,26778795          | 79,304         | 94,366         | bicubic       |
| Hardcorenas         | hardcorenas_e        | 32,2               | 0,0127                                              | 0,0143 | 0,0134 | 74,36810751          | 77,792         | 93,698         | bilinear      |
|                     | hardcorenas_f        | 32,7               | 0,0119                                              | 0,0153 | 0,0134 | 74,43488205          | 78,098         | 93,804         | bilinear      |
| LeViT               | levit_128s           | 32,8               | 0,0074                                              | 0,0098 | 0,0088 | 113,2892364          | 76,52          | 92,866         | bicubic       |
|                     | levit_128            | 39,9               | 0,0105                                              | 0,0133 | 0,0119 | 83,73827357          | 78,486         | 94,006         | bicubic       |
|                     | levit_192            | 46                 | 0,0117                                              | 0,0152 | 0,0132 | 75,49154138          | 79,832         | 94,786         | bicubic       |
|                     | levit_384            | 161                | 0,0283                                              | 0,0355 | 0,0297 | 33,61994786          | 82,588         | 96,022         | bicubic       |
| Rexnet              | rexnet_100           | 19,1               | 0,0159                                              | 0,0175 | 0,0167 | 59,84410556          | 77,858         | 93,87          | bicubic       |
|                     | rexnet_130           | 30,1               | 0,0218                                              | 0,0251 | 0,0231 | 43,34531065          | 79,5           | 94,682         | bicubic       |
|                     | rexnet_150           | 38,8               | 0,0261                                              | 0,0269 | 0,0275 | 36,31125825          | 80,31          | 95,166         | bicubic       |
|                     | rexnet_200           | 65,3               | 0,0372                                              | 0,0428 | 0,0388 | 25,76275634          | 81,628         | 95,668         | bicubic       |
| HRNet               | hrnet_w18_s          | 52,7               | 0,0231                                              | 0,0298 | 0,0253 | 39,49241333          | 72,34          | 90,678         | bilinear      |
|                     | hrnet_w18_s2         | 62,3               | 0,0367                                              | 0,0479 | 0,0416 | 24,04666871          | 75,118         | 92,416         | bilinear      |
| EfficientNet        | tf_effnet_b0_ns      | 21,1               | 0,0177                                              | 0,0246 | 0,0188 | 53,2333286           | 78,658         | 94,376         | bicubic       |
|                     | tf_effnet_v2_b0      | 28,5               | 0,0164                                              | 0,0200 | 0,0184 | 54,39716128          | 78,36          | 94,024         | bicubic       |
|                     | tf_effnet_v2_b1      | 32,4               | 0,0218                                              | 0,0264 | 0,0232 | 43,19406317          | 79,462         | 94,726         | bicubic       |
|                     | effnet_b1_pruned     | 25,3               | 0,0161                                              | 0,0178 | 0,0170 | 58,84248773          | 78,24          | 93,832         | bicubic       |
| MobileViT           | mobilevit_xxs        | 5,1                | 0,0187                                              | 0,0242 | 0,0201 | 49,69032577          | 69             | -              | bilinear      |
|                     | mobilevit_s          | 22,3               | 0,0444                                              | 0,0544 | 0,0464 | 21,56989809          | 78,4           | -              | bilinear      |
|                     | mobilevit_xs         | 9,3                | 0,0341                                              | 0,0401 | 0,0365 | 27,4318441           | 74,8           | -              | bilinear      |
| Ese                 | ese_vovnet19b_dw     | 26,2               | 0,0142                                              | 0,0174 | 0,0150 | 66,58710872          | 76,8           | 93,272         | bicubic       |
| EcaresNet           | ecaresnet50d_pruned  | 79,7               | 0,0346                                              | 0,0397 | 0,0367 | 27,26925843          | 79,71          | 94,88          | bicubic       |