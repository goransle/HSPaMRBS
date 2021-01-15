local pinInput = 1
local pinLED = 4
local throttle = 5000
local lightTime = 5000

local fancy = '```\n▄████▄   ▒█████    █████▒  █████▒▓█████ ▓█████\n'..
'▒██▀ ▀█  ▒██▒  ██▒▓██   ▒ ▓██   ▒ ▓█   ▀ ▓█   ▀\n'..
'▒▓█    ▄ ▒██░  ██▒▒████ ░ ▒████ ░ ▒███   ▒███\n'..
'▒▓▓▄ ▄██▒▒██   ██░░▓█▒  ░ ░▓█▒  ░ ▒▓█  ▄ ▒▓█  ▄\n'..
'▒ ▓███▀ ░░ ████▓▒░░▒█░    ░▒█░    ░▒████▒░▒████▒\n'..
'░ ░▒ ▒  ░░ ▒░▒░▒░  ▒ ░     ▒ ░    ░░ ▒░ ░░░ ▒░ ░\n'..
'  ░  ▒     ░ ▒ ▒░  ░       ░       ░ ░  ░ ░ ░  ░\n'..
'░        ░ ░ ░ ▒   ░ ░     ░ ░       ░      ░\n'..
'░ ░          ░ ░                     ░  ░   ░  ░\n'..
'░\n```'

local messages = {
    'It\'s coffee time!:coffee:',
    'Ready your mugs, it is time for coffee!:coffee:',
    '',
    ':coffee::coffee:',
    fancy
}

gpio.mode(pinInput, gpio.INT, gpio.PULLUP)
gpio.mode(pinLED, gpio.OUTPUT)

local posting = false
local throttled = false

local function send(message)
    if not posting and not throttled then
        posting = true

        throttled = true
        tmr.create():alarm(throttle, tmr.ALARM_SINGLE, function()
            throttled = false
        end)

        gpio.write(pinLED, gpio.HIGH)
        tmr.create():alarm(lightTime, tmr.ALARM_SINGLE, function()
            gpio.write(pinLED, gpio.LOW)
        end)

        print('Sending: "'..message..'"')

        http.post(WEBHOOK_URL, nil, '{"text":"'..message..'"}', function(code)
            posting = false
            print(code)
        end)
    end
end

local function pickRandomMessage()
    return messages[node.random(1, #messages)];
end

send(NAME.." has booted")

local function loop()
    gpio.trig(pinInput, "low", function()
        print("Down")

        gpio.trig(pinInput, "high", function()
            print("Up")

            loop()
        end)

        send(":coffee:"..pickRandomMessage())
    end)
end

loop()