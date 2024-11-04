# UVVM
My testbenches using UVVM to test various AXI and custom interfaces

## To compile uvvm_util into the Modelsim library
do ../UVVM/uvvm_util/script/compile_src.do ../UVVM/uvvm_util ./sim

## To compile bitvis_uart into the Modelsim library
do ../UVVM/uvvm_util/script/compile_src.do ../UVVM/bitvis_uart ./sim

## To compile a vhdl file
vcom -work work -2008 example.vhd

## To start a simulation e.g. uvvm_tb.vhd with entity uvvm_tb
vsim work.uvvm_tb

## To get a wave file (wave.do) on the screen 
do wave.do

## To run the simulation
run -all

## To step out
step -out

## To end the simulation
quit -sim

## Basic testbench
See file uvvm_tb.vhd. This file has a very simple testbench where it uses DUT and _vvc input/output modules the drive and read-back the input/output.
It also uses a scoreboard and prints out the data at the end.

