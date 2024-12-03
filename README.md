# UVVM
My testbenches using UVVM to test various AXI and custom interfaces

## To compile uvvm_util and uvvm_vvc_framework and the other libraries that we need into the Modelsim library
After creating your basic Modelsim project you need to do the following in the order shown below: 
~~~
do ../UVVM/uvvm_util/script/compile_src.do ../UVVM/uvvm_util ./sim
do ../UVVM/uvvm_vvc_framework/script/compile_src.do ../UVVM/uvvm_vvc_framework ./sim
do ../UVVM/bitvis_vip_scoreboard/script/compile_src.do ../UVVM/bitvis_vip_scoreboard ./sim
do ../UVVM/bitvis_vip_sbi/script/compile_src.do ../UVVM/bitvis_vip_sbi ./sim
~~~
The go to the Modelsim Project window and compile selected file. If it does not recognize the 'context' type then right click, goto properties and select the VHDL tab. In the VHDL tab click 'Use 1076-2008'. This picks the 2008 version of VHDL and context will be correctly selected.

## To compile bitvis_uart into the Modelsim library
~~~
do ../UVVM/uvvm_util/script/compile_src.do ../UVVM/bitvis_uart ./sim
~~~

## To compile a vhdl file
~~~
vcom -work work -2008 example.vhd
~~~

## To start a simulation e.g. uvvm_tb.vhd with entity uvvm_tb
~~~
vsim work.uvvm_tb
~~~

## To get a wave file (wave.do) on the screen 
~~~
do wave.do
~~~

## To run the simulation
~~~
run -all
~~~

## To step out
~~~
step -out
~~~

## To end the simulation
~~~
quit -sim
~~~

## Basic testbench
See file uvvm_tb.vhd. This file has a very simple testbench where it uses DUT and _vvc input/output modules the drive and read-back the input/output.
It also uses a scoreboard and prints out the data at the end.

### TODO
This section the steps to make a basic test bench in the UVVM environment will be added

