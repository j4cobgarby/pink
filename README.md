# pink

A simple (so far) bootloader and kernel written in nasm + C.

I've tried a different approach than I have for my last kernel. Namely,
instead of using grub, I've written my own simple bootloader. Not only
did this give me a much better understanding of bootstrapping kernels,
it also probably improved my assembly.

## Requirements for building

 - gcc.
 - A nasm assembler.

## How to build

 ```
 make
 ```

Now a file named pink.img should be in the `dist` folder.

## Emulating

If you don't want to run pink on real hardware, you'll need one of:

 - Bochs
 - QEmu

I'd suggest bochs. QEmu _works_, theoretically, but I haven't tried it.
Also, if you're going to use bochs, you can simply type `make run`, since
that just runs `bochs`, and I've already set up a `bochsrc`.

## Running pink on real hardware

It should run on most computers. It currently only supports the x86 32-bit
architecture, but as I said, most computers should support this. ARM won't,
though (so you won't be able to run it on a raspberry pi).

## Contributions

Any contributions are _very_ welcome. Just have a quick glance at my code and
make sure you're using the same indent/braces style, etc.
