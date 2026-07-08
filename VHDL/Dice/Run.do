# Stop current simulation if running
catch {quit -sim}

# Delete old compiled work library
if {[file exists work]} {
    file delete -force work
}

# Create work library inside Dice folder
vlib ./work

# Map logical library "work" to Dice/work
vmap work ./work


# Compile design files 
vcom -2008 -work work -f Design.f

# Compile testbench files 
vcom -2008 -work work -f Testbench.f

# Load testbench
vsim work.dice_tb

# Add signals and run
add wave -r *
run -all