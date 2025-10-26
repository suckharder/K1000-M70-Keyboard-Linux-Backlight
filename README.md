# K1000 (M70 Slim, and other names) Keyboard Backlight for Linux

>Cheap chinese keyboard available on various marketplaces, such as *Amazon and AliExpress*. Most commonly known as **M70 Slim keyboard** or **K1000 keyboard**, but I'm pretty sure I've seen *other names* as well.

![Keyboard Amazon Product Image Archived on archive.org](https://web.archive.org/web/20251026173007/https://m.media-amazon.com/images/I/51BPL6J1HkL._AC_SX679_PIbundle-1000,TopRight,0,0_SH20_.jpg "It's this one")

If you own this keyboard ***(backlit version only!!!)*** and are wondering why the the backlight *ONLY works in Windows*, fret no more!

**The keyboard backlight is registered as the Scroll Lock LED.**

## Requirements

- **GNU/Linux**
- **sudo**
- **systemd** (only if you want the service)
- a **text editor** you like *(I use nano)* (only if you want the service)

# Let there be light

**Simple one liner to get it to glow:**

`sudo sh -c 'echo 1 > /sys/class/leds/input1::scrolllock/brightness'`

> It probably ISN'T input1 for you, **replace 1 with your own number, for example input3::scrolllock**

## Service

In my case GNOME *(probably, not sure, don't care much)* decided to turn the Scroll Lock LED (a.k.a. the backlight) off everytime I click a password field, so I made a very stupid, very temporary service. It works fine and I couldn't care less, so I didn't bother changing it - *it's a literal infinite 5 sec check for a 0 -> if yes, 'echo 1'*.

**Make a keyboard-backlight.sh shell script in /usr/local/bin, then make it executable**:

```
#!/bin/bash
LED_PATH="/sys/class/leds/input1::scrolllock/brightness"

while true; do
    val=$(cat "$LED_PATH" 2>/dev/null)
    if [ "$val" != "1" ]; then
        echo 1 > "$LED_PATH"
    fi
    sleep 5
done
```
> AGAIN, It probably ISN'T input1 for you, **replace 1 with your own number, for example input3::scrolllock**

**Make a keyboard-backlight.service service in /etc/systemd/system**:

```
[Unit]
Description=Keep keyboard backlight on (via Scroll Lock LED)
After=multi-user.target

[Service]
ExecStart=/usr/local/bin/keyboard-backlight.sh
Restart=always

[Install]
WantedBy=multi-user.target
```

**Enable and start the service**:

`sudo systemctl enable --now keyboard-backlight.service`

That's it :)
