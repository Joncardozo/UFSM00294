# TCL ModelSim compile script

# Cria a work library, se não existir
if { ![file exist work] } {
    vlib work
}

# Lista de arquivos em ordem hierárquica
set sourceFiles {
    MIPS_pkg.vhd
    Util_pkg.vhd
    Memory.vhd
    Timer.vhd
    BidirectionalPort.vhd
    PriorityEncoder.vhd
    InterruptController.vhd
    UART_RX.vhd
    UART_TX.vhd
    peripheral_controller.v
    MIPS_monocycle.vhd
    MIPS_uC.v
    MIPS_uC_tb.v
}
set top MIPS_uC_tb.v

# Compila arquivos separadamente por linguagem
foreach file $sourceFiles {
    if {[file extension $file] == ".vhd"} {
        if [catch {vcom $file}] {
            puts "\n*** ERROR compiling VHDL file $file :( ***"
            return
        }
    } elseif {[file extension $file] == ".v"} {
        if [catch {vlog $file}] {
            puts "\n*** ERROR compiling Verilog file $file :( ***"
            return
        }
    }
}

# Lista os arquivos compilados
puts "\n*** Compiled files:"
foreach file $sourceFiles {
    puts \t$file
}

# Define o top-level module
set top MIPS_uC_tb
# vsim $top ;# Descomente se quiser rodar automaticamente

puts "\n*** Compilation OK ;) ***"

