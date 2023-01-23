#
# cn0540 project to Auto Board conversion
# 2022/01/09 - chris at acresearchinc
#
#

set REQUIRED_QUARTUS_VERSION 21.1.1
set QUARTUS_PRO_ISUSED 0
source ../../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project autoboard_dual_lpf_de10nano

source $ad_hdl_dir/projects/common/de10nano/de10nano_system_assign.tcl

#
## down-rade Critical Warning reated to a asynchronous RAM in DMAC
#
## "mixed_port_feed_through_mode" parameter of RAM can not have value "old"
set_global_assignment -name MESSAGE_DISABLE 15003

# LPF 1
set_location_assignment PIN_AA15 -to cn0540_spi_sclk      ; #SCLK (2B) is on GPIO1:3
# was:
#set_location_assignment PIN_AG26 -to cn0540_spi_cs        ; #CS   (5E) is on GPIO1:9
set_location_assignment PIN_AG26 -to cn0540_spi_cs[0]        ; #CS  (XXX fix)
set_location_assignment PIN_AH27 -to cn0540_spi_cs[1]        ; #CS  (xxx fix)
set_location_assignment PIN_AE25 -to cn0540_spi_mosi      ; #MOSI (4D) is on GPIO1:7
set_location_assignment PIN_Y15  -to cn0540_spi_miso      ; #MISO (1A) is on GPIO1:1

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn0540_spi_sclk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn0540_spi_miso
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn0540_spi_mosi
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn0540_spi_cs

# LPF 2 CS is on GPIO1 pin 8
# alex removed
#set_location_assignment PIN_AH27 -to cn0540_shutdown      ; ## GPIO1, pin 8 is CS for LPF2

# I2C

set_location_assignment PIN_AG11  -to i2c_scl             ; ##   Arduino_IO15
set_location_assignment PIN_AH9   -to i2c_sda             ; ##   Arduino_IO14

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to i2c_scl
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to i2c_sda

# reset and GPIO signals

# alex reinstated
set_location_assignment PIN_AE15 -to cn0540_shutdown      ; ##   Arduino_IO9
#set_location_assignment PIN_AH8  -to cn0540_reset_adc     ; ##   Arduino_IO7

# Slow ADC Continued...
set_location_assignment PIN_AF25 -to cn0540_reset_adc     ; ## GPIO1:16 [GPIO1_13], CONVST

##### whole bunch of extra defined pins, leave them at arduino header for now #####

set_location_assignment PIN_U13  -to cn0540_csb_aux       ; ##   Arduino_IO5
set_location_assignment PIN_U14  -to cn0540_sw_ff         ; ##   Arduino_IO4
set_location_assignment PIN_AG9  -to cn0540_drdy_aux      ; ##   Arduino_IO3
set_location_assignment PIN_AF13 -to cn0540_blue_led      ; ##   Arduino_IO1
set_location_assignment PIN_AG13 -to cn0540_yellow_led    ; ##   Arduino_IO0

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn0540_shutdown
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn0540_reset_adc
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn0540_csb_aux
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn0540_sw_ff
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn0540_drdy_aux
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn0540_blue_led
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn0540_yellow_led

# synchronization and timing

set_location_assignment PIN_AG8  -to cn0540_sync_in       ; ##   Arduino_IO6
set_location_assignment PIN_AG10 -to cn0540_drdy          ; ##   Arduino_IO2

set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn0540_sync_in
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to cn0540_drdy
##### end extra pins at arduino header #####
#
execute_flow -compile
