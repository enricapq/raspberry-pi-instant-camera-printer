# Raspberry Pi instant camera printer 

<a href="https://www.raspberrypi.org"><img src="https://www.raspberrypi.org/wp-content/uploads/2012/03/raspberry-pi-logo.png" alt="Raspberry Pi Logo" align="left" style="margin-right: 25px" height=150></a>

> Components:
> * [Raspberry Pi 3 Model B](https://www.raspberrypi.org/products/raspberry-pi-3-model-b/)
> * [Mini thermal printer](https://www.adafruit.com/product/597)
> * 2 x LED Tactile Button
> * Breadboard
> * Jumper Jerky
> * 5-9VDC @ 1.5Amp power supply or 4 x AA Battery Holder with On/Off Switch
> * cardboard box

<p align="center">
<img src="https://github.com/enricapq/raspberry-pi-instant-camera-printer/blob/Add-image/misc/raspberry-pi-instant-camera-printer.jpg" alt="raspberry-pi-instant-camera-printer" width=600 height=387>
</p>

This is a fork of [https://github.com/adafruit/zj-58](https://github.com/adafruit/zj-58)


zj-58
=====

CUPS filter for thermal printer Zjiang ZJ-58

The linux driver provided on Zjiang site unfortunately doesn't work.
First, it is 32-bit binary (and so, on x64 system need some x86 libs to be installed).
Second, it's PPD is not correct - it just doesn't show any advanced settings because of it.
Finally, raster filter just crashes on any try to run it!
But even if you run it, you'll see that it's working with printer is not optimal: for example, if it sees a blank line, it will send the blank raster to print (instead of just use 'feeding' command, which is definitely faster!)

This is the solution:
PPD is fixed and works.
Filter is provided as src (you can found a list of packages need to be installed in order to build it in the header of source).
Also, printing of blank lines is optimized.

In order to re-compile the binary (e.g. on a Raspberry Pi), the following libraries must be installed:

```
sudo apt-get install libcups2-dev libcupsimage2-dev g++ cups cups-client
```

After that, `make` and `install` do the right thing.
