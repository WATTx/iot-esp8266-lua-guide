# ESP8266 + Lua

I used **Wemos D1-mini** and **NodeMCU Amica** board. It wasn't easy, but eventually I managed to make it work.

### Requirements

- Python + pip
- [Wemos Driver](http://www.wemos.cc/downloads/)
- [ESPtool](https://github.com/themadinventor/esptool)
- [nodemcu-tool](https://github.com/AndiDittrich/NodeMCU-Tool)
- [LuaTool](https://github.com/4refr0nt/luatool)

### Useful links

- [Wemos - get started in nodemcu](http://www.wemos.cc/tutorial/get_started_in_nodemcu.html)
- [NodeMCU build](https://nodemcu-build.com/)
- [NodeMCU firmware](https://github.com/nodemcu/nodemcu-firmware)
- [NodeMCU documentation](https://nodemcu.readthedocs.io/en/dev/)
- [NodeLua](https://nodelua.org/) - couldn't run it on D1-mini

### How to Flash

(My device name is: `cu.wchusbserial1410` – if you use Linux the name might be different - you can easily find it out by listing `/dev/` directoy)

1. Install tools from the requirements.
2. Connect your board and erase everything from the flash memory:

	```
sudo esptool.py --port /dev/cu.wchusbserial1410 erase_flash
	```

3. Now we can upload `bin` file to your module (`--verify` flag will check if digest matches)

	```
sudo esptool.py --port /dev/cu.wchusbserial1410 --baud 9600 write_flash 0x00000 ./bin/nodemcu-master-7-modules-2016-09-14-16-58-11-float.bin 0x3fc000 ./bin/esp_init_data_default.bin -fm dio -fs 32m
	```

	(Change the path to `bin` file if you're going to use custom firmware)

4. Once it's ready you should see logs like this:

	```
esptool.py v1.1
Connecting...
Running Cesanta flasher stub...
Flash params set to 0x0000
Writing 364544 @ 0x0... 364544 (100 %)
Wrote 364544 bytes at 0x0 in 31.5 seconds (92.5 kbit/s)...
Leaving...
Verifying just-written flash...
Verifying 0x587fc (362492) bytes @ 0x00000000 in flash against bin/nodemcu-master-10-modules-2015-09-29-17-58-26-integer.bin...
-- verify OK (digest matched)
	```

5. You have to **REBOOT** your board by clicking the `Reset` button. The LED should blink once. If it's blinking like crazy, probably something went wrong while uploading your `firmware`. Try to repeat all steps: erase & upload and make sure that your are setting `-fm` and `-fs`.


### Uploading Lua files

##### Using ESPlorer

1. Download [ESPtool](https://github.com/themadinventor/esptool).
2. **Connect** to your board.
3. Open / Create lua script.
4. Click **Save to ESP**

#### Using nodemcu-tool

1. Install [nodemcu-tool](https://github.com/AndiDittrich/NodeMCU-Tool)

	```
npm i -g nodemcu-tool
	```

2. Upload Lua file:

	```
nodemcu-tool --port /dev/cu.wchusbserial1410 upload ./lua/led/init.lua
	```

3. Press **Reset** button

**NodeMCU-Tool** offers more useful commands:

```
fsinfo [options]             Show file system info (current files, memory usage)
run <file>                   Executes an existing .lua or .lc file on NodeMCU
upload [options] [files...]  Upload Files to NodeMCU (ESP8266) target
download <file>              Download files from NodeMCU (ESP8266) target
remove <file>                Removes a file from NodeMCU filesystem
mkfs [options]               Format the SPIFFS filesystem - ALL FILES ARE REMOVED
terminal [options]           Opens a Terminal connection to NodeMCU
init                         Initialize a project-based Configuration (file) within current directory
devices [options]            Shows a list of all available NodeMCU Modules/Serial Devices
reset [options]              Execute a Hard-Reset of the Module using DTR/RTS reset circuit
```


##### Using luatool.py

1. Run `luatool.py`

	```
sudo luatool.py -p /dev/cu.wchusbserial1410 --src ./lua/led.lua --dest init.lua --verbose
	```

	Your console should print 4 Stages:

	```
	Upload starting

	Stage 1. Deleting old file from flash memory
	->file.open("init.lua", "w") -> ok
	->file.close() -> ok

	Stage 2. Creating file in flash memory and write first line->file.remove("init.lua") -> ok

	Stage 3. Start writing data to flash memory...->file.open("init.lua", "w+") -> ok
	-> ...


	Stage 4. Flush data and closing file->file.writeline([==[tmr.alarm(0, duration, 1, blink)]==]) -> ok
	->file.flush() -> ok
	->file.close() -> ok

	--->>> All done <<<---
	```

2. Press the `Reset` button.
3. LED should start blinking.


### Makefile

(Check your device name and replace if needed)

- `make erase` will erase everything from the flash memory
- `make flash` will upload binary file


### Thoughts

It ain't so easy to use Lua together with D1-mini board. Sometimes firmware produces garbage output on the console (https://github.com/nodemcu/nodemcu-firmware/issues/1474). I still didn't figure it out why it's happening.

It would be great to have IDE like Arduino where everything works out of the box.

###### UPDATE:

I tried to flash **AI-Thinker** module and everything went smooth but I couldn't use ESPlorer. I had to switch to `nodemcu-tool` which is perfect if you prefer to use CLI.

### Lua resources

- https://www.lua.org/docs.html
- https://github.com/kikito/lua_missions
- https://github.com/LewisJEllis/awesome-lua
