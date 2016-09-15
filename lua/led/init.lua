-- config

-- GPIO2 -> pin 4
local pin = 4
local value = gpio.LOW
local duration = 1000

function blink ()
  if value == gpio.LOW then
    value = gpio.HIGH
  else
    value = gpio.LOW
  end

  gpio.write(pin, value)
end

-- main

gpio.mode(pin, gpio.OUTPUT)
gpio.write(pin, value)

tmr.alarm(0, duration, 1, blink)
