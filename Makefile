DEVICE = /dev/cu.wchusbserial1410
BIN = ./bin/nodemcu-master-7-modules-2016-09-14-16-58-11-float.bin
BIN_DEFAULT = ./bin/esp_init_data_default.bin

ESPTOOL = esptool.py

erase:
	sudo $(ESPTOOL) --port $(DEVICE) erase_flash

flash:
	sudo $(ESPTOOL) --port $(DEVICE) write_flash 0x00000 $(BIN) 0x3fc000 $(BIN_DEFAULT) -fm dio -fs 32m --verify
