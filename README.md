# profanity3

Profanity is a high performance (probably the fastest!) vanity address generator for Ethereum. Create cool customized addresses that you never realized you needed! Receive Ether in style! Wow!

This is a fork of "profanity2", which is in turn a fork of the original "profanity".

Because of extreme creativity, this third fork is called "profanity3".

This repo right here, "profanity3", is the same as "profanity2" with just one special feature: it can crack "profanity1" keys.

![Screenshot](/img/screenshot.png?raw=true "Wow! That's a lot of zeros!")

# Important to know

A previous version of this project (hereby called "profanity1" for context) has a known critical issue due to a bad source of randomness. The issue enables attackers to recover the private key given a public key: https://blog.1inch.io/a-vulnerability-disclosed-in-profanity-an-ethereum-vanity-address-tool-68ed7455fc8c

The good guys at 1inch created a follow-up project called "profanity2" which was forked from the original "profanity1" project and modified to guarantee **safety by design**. They claim that "this means that the source code of this project does not require any audits, but still guarantee safe usage." Kind of a bold statement (if you ask me) although it's pretty much true.

The "profanity2" project is not generating keys anymore (as opposed to "profanity1"). Instead, it adjusts a user-provided public key until a desired vanity address is discovered. Users provide a seed public key in the form of a 128-symbol hex string with the `-z` parameter flag. The resulting private key should then be added to the seed private key to achieve a final private key with the desired vanity address (remember: private keys are just 256-bit numbers). Running "profanity2" can even be outsourced to someone completely unreliable - it is still safe by design.

## Getting public key for mandatory `-z` parameter

Generate private key and public key via openssl in terminal (remove prefix "04" from public key):
```bash
$ openssl ecparam -genkey -name secp256k1 -text -noout -outform DER | xxd -p -c 1000 | sed 's/41534e31204f49443a20736563703235366b310a30740201010420/Private Key: /' | sed 's/a00706052b8104000aa144034200/\'$'\nPublic Key: /'
```

Derive public key from existing private key via openssl in terminal (remove prefix "04" from public key):
```bash
$ openssl ec -inform DER -text -noout -in <(cat <(echo -n "302e0201010420") <(echo -n "PRIVATE_KEY_HEX") <(echo -n "a00706052b8104000a") | xxd -r -p) 2>/dev/null | tail -6 | head -5 | sed 's/[ :]//g' | tr -d '\n' && echo
```

## Adding private keys (never use online calculators!)

### Terminal:

Use private keys as 64-symbol hexadecimal string WITHOUT `0x` prefix:
```bash
(echo 'ibase=16;obase=10' && (echo '(PRIVATE_KEY_A + PRIVATE_KEY_B) % FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F' | tr '[:lower:]' '[:upper:]')) | bc
```

### Python

Use private keys as 64-symbol hexadecimal string WITH `0x` prefix:
```bash
$ python3
>>> hex((PRIVATE_KEY_A + PRIVATE_KEY_B) % 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F)
```

# Usage
```
usage: ./profanity3 [OPTIONS]

  Mandatory args:
    -z                      Seed public key to start, add it's private key
                            to the "profanity3" resulting private key.

  Basic modes:
    --benchmark             Run without any scoring, a benchmark.
    --zeros                 Score on zeros anywhere in hash.
    --letters               Score on letters anywhere in hash.
    --numbers               Score on numbers anywhere in hash.
    --mirror                Score on mirroring from center.
    --leading-doubles       Score on hashes leading with hexadecimal pairs

  Modes with arguments:
    --leading <single hex>  Score on hashes leading with given hex character.
    --matching <hex string> Score on hashes matching given hex string.

  Advanced modes:
    --contract              Instead of account address, score the contract
                            address created by the account's zeroth transaction.
    --leading-range         Scores on hashes leading with characters within
                            given range.
    --range                 Scores on hashes having characters within given
                            range anywhere.

  Range:
    -m, --min <0-15>        Set range minimum (inclusive), 0 is '0' 15 is 'f'.
    -M, --max <0-15>        Set range maximum (inclusive), 0 is '0' 15 is 'f'.

  Device control:
    -s, --skip <index>      Skip device given by index.
    -n, --no-cache          Don't load cached pre-compiled version of kernel.

  Tweaking:
    -w, --work <size>       Set OpenCL local work size. [default = 64]
    -W, --work-max <size>   Set OpenCL maximum work size. [default = -i * -I]
    -i, --inverse-size      Set size of modular inverses to calculate in one
                            work item. [default = 255]
    -I, --inverse-multiple  Set how many above work items will run in
                            parallell. [default = 16384]

  Examples:
    ./profanity3 --leading f -z HEX_PUBLIC_KEY_128_CHARS_LONG
    ./profanity3 --matching dead -z HEX_PUBLIC_KEY_128_CHARS_LONG
    ./profanity3 --matching badXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXbad -z HEX_PUBLIC_KEY_128_CHARS_LONG
    ./profanity3 --leading-range -m 0 -M 1 -z HEX_PUBLIC_KEY_128_CHARS_LONG
    ./profanity3 --leading-range -m 10 -M 12 -z HEX_PUBLIC_KEY_128_CHARS_LONG
    ./profanity3 --range -m 0 -M 1 -z HEX_PUBLIC_KEY_128_CHARS_LONG
    ./profanity3 --contract --leading 0 -z HEX_PUBLIC_KEY_128_CHARS_LONG

  About:
    profanity3 is a vanity address generator for Ethereum that utilizes
    computing power from GPUs using OpenCL.

  Forked "profanity3":
    Author: Rodrigo Madera <madera@acm.org>
    Disclaimer:
      This project "profanity3" was forked from the "profanity2" project and
      modified to allow you to assess the quality of your "profanity1" keys.
      No guarantees whatsoever are given, so use this at your own risk and
      don't bother me about it. Also, don't be evil. Use this to assess
      your own addresses and keep them safe. But better yet, if you have
      any wallets generated with profanity1, just throw them away.

  Forked "profanity2":
    Author: 1inch Network <info@1inch.io>
    Disclaimer:
      The project "profanity2" was forked from the original project and
      modified to guarantee "SAFETY BY DESIGN". This means source code of
      this project doesn't require any audits, but still guarantee safe usage.

  From original "profanity":
    Author: Johan Gustafsson <profanity@johgu.se>
    Beer donations: 0x000dead000ae1c8e8ac27103e4ff65f42a4e9203
    Disclaimer:
      Always verify that a private key generated by this program corresponds to
      the public key printed by importing it to a wallet of your choice. This
      program like any software might contain bugs and it does by design cut
      corners to improve overall performance.
```

### Compile for Windows

- Install MSYS2
- Open MSYS2 MINIGW64 shell
- ```pacman -S mingw-w64-x86_64-toolchain mingw-w64-x86_64-opencl-headers```
- ```pacman -S base-devel gcc vim cmake```
- cd /C/DOWNLOADS/profanity3-master
- make
- ./profanity3.exe

### Compile for Linux

- sudo apt-get update && sudo apt-get upgrade
- sudo apt-get install opencl-headers
- sudo apt-get install ocl-icd-opencl-dev intel-opencl-icd
- make
- make clean
- chmod +x ./profanity3.x64
- ./profanity3.x64

### Benchmarks - Current version
|Model|Clock Speed|Memory Speed|Modified straps|Speed|Time to match eight characters
|:-:|:-:|:-:|:-:|:-:|:-:|
|GTX 3070| | |NO|441.0 MH/s| ~10s
|GTX 1070 OC|1950|4450|NO|179.0 MH/s| ~24s
|GTX 1070|1750|4000|NO|163.0 MH/s| ~26s
|RX 480|1328|2000|YES|120.0 MH/s| ~36s
|Apple Silicon M1<br/>(8-core GPU)|-|-|-|45.0 MH/s| ~97s
|Apple Silicon M1 Max<br/>(32-core GPU)|-|-|-|172.0 MH/s| ~25s

