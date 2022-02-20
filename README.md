# Backbone-Runtime
This repository provides code for initializing, testing, and measuring the running time of neural networks on Apple devices.

## Device
Measurements were taken using the **Iphone 8 emulator on a MacBook Air (2020) M1 8GB**.
**OS: Monterey 12.1**.

## Inference
During testing were open: Safari, Xcode (=> Emulator) and Terminal.

Time was measured for each model individually (i.e. there was only one model in the "models" folder).

## Сonfiguration
The models were initialized using [timm](https://github.com/rwightman/pytorch-image-models). MobileViT have been initialized in the [cvnets repo](https://github.com/apple/ml-cvnets/blob/main/main_conversion.py#L26).

The models have normalization and taking the top 5 probabilities. The models were converted using [coremltools](https://github.com/apple/coremltools). More: [ipynb](Create%20models.ipynb).

## Benchmark

<table>
    <thead align="center">
        <tr>
            <th rowspan="2"><span style="font-weight:bold">Architecture family</</th>
            <th rowspan="2">Model name</th>
            <th rowspan="2">MLmodel weight, MB</th>
            <th colspan="3">Running time (100 starts) on emulator Iphone 8, sec</th>
            <th rowspan="2">Average frames / sec</th>
            <th colspan="2">Metrics</th>
            <th rowspan="2">Interpolation</th>
        </tr>
        <tr>
            <td>Min</td>
            <td>Max</td>
            <td>Avg</td>
            <td>ImageNet<br>top-1</td>
            <td>ImageNet<br>top-5</td>
        </tr>
    </thead>
    <tbody align="center">
        <tr>
            <td rowspan="4">MobileNet</td>
            <td align="center">mn2_100</td>
            <td>14.7</td>
            <td>0.0090</td>
            <td>0.0114</td>
            <td>0.0100</td>
            <!-- <td><b>3.39</b></td> -->
            <td><b>99.86482083</b></td>
            <td>72.952</td>
            <td>91.002</td>
            <!-- <td><ins>2.51</ins></td> -->
            <td>bicubic</td>
        </tr>
        <tr>
            <td align="center">mn2_110d</td>
            <td>18</td>
            <td>0.0128</td>
            <td>0.0152</td>
            <td>0.0137</td>
            <td>72.92339643</td>
            <td>75.052</td>
            <td>92.188</td>
            <td>bicubic</td>
        </tr>
        <tr>
            <td align="center">mn3_rw</td>
            <td>21.9</td>
            <td>0.0078</td>
            <td>0.0098</td>
            <td>0.0087</td>
            <td><b>115.1641272</b></td>
            <td>75.63</td>
            <td>92.708</td>
            <td>bicubic</td>
        </tr>
        <tr>
            <td align="center">mn3_large_100_miil</td>
            <td>21.9</td>
            <td>0.0074</td>
            <td>0.0090</td>
            <td>0.0084</td>
            <td><b>118.5257193</b></td>
            <td>77.918</td>
            <td>92.906</td>
            <td>bicubic</td>
        </tr>
        <tr>
            <td rowspan="2">Gernet</td>
            <td align="center">gernet_s</td>
            <td>32.6</td>
            <td>0.0111</td>
            <td>0.0188</td>
            <td>0.0125</td>
            <td>79.71578839</td>
            <td>76.912</td>
            <td>93.134</td>
            <td>bilinear</td>
        </tr>
        <tr>
            <td align="center">gernet_m</td>
            <td>84.4</td>
            <td>0.0293</td>
            <td>0.0397</td>
            <td>0.0309</td>
            <td>32.32946595</td>
            <td>80.746</td>
            <td>95.184</td>
            <td>bilinear</td>
        </tr>
        <tr>
            <td rowspan="2">Pit</td>
            <td align="center">pit_xs_224</td>
            <td>49.5</td>
            <td>0.0469</td>
            <td>0.0520</td>
            <td>0.0495</td>
            <td>20.21368422</td>
            <td>78.188</td>
            <td>94.166</td>
            <td>bicubic</td>
        </tr>
        <tr>
            <td align="center">pit_xs_distilled_224</td>
            <td>44</td>
            <td>0.0464</td>
            <td>0.0514</td>
            <td>0.0493</td>
            <td>20.26778795</td>
            <td>79.304</td>
            <td>94.366</td>
            <td>bicubic</td>
        </tr>
        <tr>
            <td rowspan="2">Hardcorenas</td>
            <td align="center">hardcorenas_e</td>
            <td>32.2</td>
            <td>0.0127</td>
            <td>0.0143</td>
            <td>0.0134</td>
            <td>74.36810751</td>
            <td>77.792</td>
            <td>93.698</td>
            <td>bilinear</td>
        </tr>
        <tr>
            <td align="center">hardcorenas_f</td>
            <td>32.7</td>
            <td>0.0119</td>
            <td>0.0153</td>
            <td>0.0134</td>
            <td>74.43488205</td>
            <td>78.098</td>
            <td>93.804</td>
            <td>bilinear</td>
        </tr>
        <tr>
            <td rowspan="4">LeViT</td>
            <td align="center">levit_128s</td>
            <td>32.8</td>
            <td>0.0074</td>
            <td>0.0098</td>
            <td>0.0088</td>
            <td><b>113.2892364</b></td>
            <td>76.52</td>
            <td>92.866</td>
            <td>bicubic</td>
        </tr>
        <tr>
            <td align="center">levit_128</td>
            <td>39.9</td>
            <td>0.0105</td>
            <td>0.0133</td>
            <td>0.0119</td>
            <td>83.73827357</td>
            <td>78.486</td>
            <td>94.006</td>
            <td>bicubic</td>
        </tr>
        <tr>
            <td align="center">levit_192</td>
            <td>46</td>
            <td>0.0117</td>
            <td>0.0152</td>
            <td>0.0132</td>
            <td>75.49154138</td>
            <td>79.832</td>
            <td>94.786</td>
            <td>bicubic</td>
        </tr>
        <tr>
            <td align="center">levit_384</td>
            <td>161</td>
            <td>0.0283</td>
            <td>0.0355</td>
            <td>0.0297</td>
            <td>33.61994786</td>
            <td>82.588</td>
            <td>96.022</td>
            <td>bicubic</td>
        </tr>
        <tr>
            <td rowspan="4">RexNet</td>
            <td align="center">rexnet_100</td>
            <td>19.1</td>
            <td>0.0159</td>
            <td>0.0175</td>
            <td>0.0167</td>
            <td>59.84410556</td>
            <td>77.858</td>
            <td>93.87</td>
            <td>bicubic</td>
        </tr>
        <tr>
            <td align="center">rexnet_130</td>
            <td>30.1</td>
            <td>0.0218</td>
            <td>0.0251</td>
            <td>0.0231</td>
            <td>43.34531065</td>
            <td>79.5</td>
            <td>94.682</td>
            <td>bicubic</td>
        </tr>
        <tr>
            <td align="center">rexnet_150</td>
            <td>38.8</td>
            <td>0.0260</td>
            <td>0.0268</td>
            <td>0.0267</td>
            <td>37.45697546</td>
            <td>80.31</td>
            <td>95.166</td>
            <td>bicubic</td>
        </tr>
        <tr>
            <td align="center">rexnet_200</td>
            <td>65.3</td>
            <td>0.0372</td>
            <td>0.0428</td>
            <td>0.0388</td>
            <td>25.76275634</td>
            <td>81.628</td>
            <td>95.668</td>
            <td>bicubic</td>
        </tr>
        <tr>
            <td rowspan="2">HRNet</td>
            <td align="center">hrnet_w18_s</td>
            <td>52.7</td>
            <td>0.0231</td>
            <td>0.0298</td>
            <td>0.0253</td>
            <td>39.49241333</td>
            <td>72.34</td>
            <td>90.678</td>
            <td>bilinear</td>
        </tr>
        <tr>
            <td align="center">hrnet_w18_s2</td>
            <td>62.3</td>
            <td>0.0367</td>
            <td>0.0479</td>
            <td>0.0416</td>
            <td>24.04666871</td>
            <td>75.118</td>
            <td>92.416</td>
            <td>bilinear</td>
        </tr>
        <tr>
            <td rowspan="4">EfficientNet</td>
            <td align="center">tf_effnet_b0_ns</td>
            <td>21.1</td>
            <td>0.0177</td>
            <td>0.0246</td>
            <td>0.0188</td>
            <td>53.2333286</td>
            <td>78.658</td>
            <td>94.376</td>
            <td>bicubic</td>
        </tr>
        <tr>
            <td align="center">tf_effnet_v2_b0</td>
            <td>28.5</td>
            <td>0.0164</td>
            <td>0.0200</td>
            <td>0.0184</td>
            <td>54.39716128</td>
            <td>78.36</td>
            <td>94.024</td>
            <td>bicubic</td>
        </tr>
        <tr>
            <td align="center">tf_effnet_v2_b1</td>
            <td>32.4</td>
            <td>0.0218</td>
            <td>0.0264</td>
            <td>0.0232</td>
            <td>43.19406317</td>
            <td>79.462</td>
            <td>94.726</td>
            <td>bicubic</td>
        </tr>
        <tr>
            <td align="center">effnet_b1_pruned</td>
            <td>25.3</td>
            <td>0.0161</td>
            <td>0.0178</td>
            <td>0.0170</td>
            <td>58.84248773</td>
            <td>78.24</td>
            <td>93.832</td>
            <td>bicubic</td>
        </tr>
        <tr>
            <td rowspan="3">MobileViT</td>
            <td align="center">mobilevit_xxs</td>
            <td>5.1</td>
            <td>0.0187</td>
            <td>0.0242</td>
            <td>0.0201</td>
            <td>49.69032577</td>
            <td>69</td>
            <td>-</td>
            <td>bilinear</td>
        </tr>
        <tr>
            <td align="center">mobilevit_xs</td>
            <td>9.3</td>
            <td>0.0341</td>
            <td>0.0401</td>
            <td>0.0365</td>
            <td>27.4318441</td>
            <td>74.8</td>
            <td>-</td>
            <td>bilinear</td>
        </tr>
        <tr>
            <td align="center">mobilevit_s</td>
            <td>22.3</td>
            <td>0.0444</td>
            <td>0.0544</td>
            <td>0.0464</td>
            <td>21.56989809</td>
            <td>78.4</td>
            <td>-</td>
            <td>bilinear</td>
        </tr>
        <tr>
            <td rowspan="1">Ese</td>
            <td align="center">ese_vovnet19b_dw</td>
            <td>26.2</td>
            <td>0.0142</td>
            <td>0.0174</td>
            <td>0.0150</td>
            <td>66.58710872</td>
            <td>76.8</td>
            <td>93.272</td>
            <td>bicubic</td>
        </tr>
        <tr>
            <td rowspan="1">EcaresNet</td>
            <td align="center">ecaresnet50d_pruned</td>
            <td>79.7</td>
            <td>0.0346</td>
            <td>0.0397</td>
            <td>0.0367</td>
            <td>27.26925843</td>
            <td>79.71</td>
            <td>94.88</td>
            <td>bicubic</td>
        </tr>
    </tbody>
</table>

