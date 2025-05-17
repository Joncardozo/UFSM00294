!/bin/bash
# This script compiles the VHDL files for the MIPS Monocycle processor simulation.

ghdl -a ../src/VHDL/Memory/Util_pkg.vhd
ghdl -a ../src/VHDL/Memory/Memory.vhd
ghdl -a ../src/VHDL/MIPS/MIPS_pkg.vhd
ghdl -a ../src/VHDL/MIPS/MIPS_monocycle.vhd
ghdl -a Decoder.vhd
ghdl -a Timer.vhd
ghdl -a BidirectionalPort.vhd
ghdl -a MIPS_monocycle_tb.vhd
ghdl -e MIPS_monocycle_tb
ghdl -r MIPS_monocycle_tb --wave=wave.ghw --stop-time=100000ns
gtkwave wave.ghw