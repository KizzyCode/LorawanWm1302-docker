# kizzycode/lorawan-wm1302-eu868-usb

LoRaWAN coordinator middleware for
[Seeed Studio WM1302 EU868 USB](https://www.seeedstudio.com/WM1302-LoRaWAN-Gateway-Module-USB-EU868-p-4892.html).

## Note
This docker container uses a [fork](https://github.com/KizzyCode/fork--sx1302_hal/tree/master) of the
[original middleware](https://github.com/Lora-net/sx1302_hal), where the close-to-broken install process via `ssh`/`scp`
has been patched to perform a local `cp`.
