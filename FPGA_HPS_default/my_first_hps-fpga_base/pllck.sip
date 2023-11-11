set_global_assignment -entity "pllck" -library "lib_pllck" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "pllck" -library "lib_pllck" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "pllck" -library "lib_pllck" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_pllck" -name SPD_FILE [file join $::quartus(sip_path) "pllck.spd"]

set_global_assignment -library "lib_pllck" -name MISC_FILE [file join $::quartus(sip_path) "pllck_sim/pllck.vo"]
