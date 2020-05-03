#!/bin/bash

# Power Management
#
# Manage system power mode. Controlling cpu power state, msi fan curves and
# and intel speedboost.
#
# Requirements
# Fan Control: isw
#

#########################
# Vars
#########################

# ISW powersave profile name
ISW_PS_PROFILE="16Q2EMS1"
# ISW performance profile name
ISW_PF_PROFILE="16Q2EMS11"
# ISW balanced profile name
ISW_B_PROFILE="16Q2EMS12"


##########################
# functions
#########################

function performance_toggles() {
  # Reduce vm writeback time
  echo '6000' > sudo tee /proc/sys/vm/dirty_writeback_centisecs

  # Disable NMI Watchdog
  echo '0' > sudo tee /proc/sys/kernel/nmi_watchdog

  # Enable Audio powersaving
  echo '1' > sudo tee /sys/module/snd_hda_intel/parameters/power_save
}

function to_powersave() {
  # Set fan profile
  sudo isw -w "$ISW_PS_PROFILE"

  # Set CPU scaling governor to powersave
  echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

  # Set energy preference
  echo "power" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference

  # Disable turbo boost
  echo "1" | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo

  echo "powersave" > $POWER_PATH
}

function to_performance() {
  # Set fan profile
  sudo isw -w "$ISW_PF_PROFILE"

  # Set CPU scaling governor to performance
  # Runs all cores at maximum speed
  echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

  # Set energy preference
  echo "performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference

  # Enable turbo boost
  echo '0' | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo

  echo "powersave" > $POWER_PATH
}

function to_balanced() {
  # Set fan profile
  sudo isw -w "$ISW_B_PROFILE"

  # Set CPU scaling governor to powersave for all cores
  echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

  # Set energy preference
  echo "balance_performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference

  # Enable turbo boost
  echo "0" | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo

  echo "balanced" > $POWER_PATH
}


#########################
# Finalize
#########################

case "$1" in
  "toggle")
    power_toggle
    ;;
  "powersave")
    to_powersave
    ;;
  "balanced")
    to_balanced
    ;;
  "performance")
    to_performance
    ;;
esac

