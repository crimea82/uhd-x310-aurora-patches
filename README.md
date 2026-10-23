# UHD X310 Aurora OOT Patches

Patches against UHD 4.10.0.0 that enable building an out-of-tree Aurora RFNoC
block for the X310. Ported from the X410 in-tree implementation.

## What the patches change

- `fpga/usrp3/top/x300/` — Makefile, `bus_int.v`, `x300.v`, `x300_core.v`: wires
  aurora ports into the X310 FPGA design and adds `X310_AA` / `X310_AA1` build targets
- `host/include/uhd/rfnoc/core/io_signatures.yml`: adds `x3xx_sfpp_aurora` port type
- `host/include/uhd/rfnoc/core/x310_bsp.yml`: exposes `sfpp0`/`sfpp1` aurora ports
- `host/utils/rfnoc_image_builder.py`: minor fix required for the new targets
- `fpga/usrp3/top/x300/setupenv.sh`, `fpga/usrp3/tools/make/viv_preamble.mak`:
  update Vivado version to 2024.2 and fix case-sensitive version string grep
- `fpga/usrp3/lib/axi4s_sv/`: guard `$fatal` assertions in `initial` blocks with
  `synthesis translate_off/on` — Vivado 2024.2 synthesizes these where 2021.1 did not

## Usage

```
make          # clone UHD v4.10.0.0 from Ettus and apply patches
make clean    # remove the cloned source tree
```

The source repo URL and version can be overridden:

```
make UHD_REPO=https://github.com/EttusResearch/uhd.git
```

## Building and installing patched UHD

After running `make`, build and install the UHD host software:

```bash
cd uhd/host
mkdir -p build && cd build
cmake ..
make -j$(nproc)
sudo cmake --install .
```

This installs the files that `rfnoc_image_builder` reads from the system path:

- `/usr/local/bin/rfnoc_image_builder` — updated with X310_AA targets
- `/usr/local/share/uhd/rfnoc/core/io_signatures.yml` — adds `x3xx_sfpp_aurora` type
- `/usr/local/share/uhd/rfnoc/core/x310_bsp.yml` — adds `sfpp0`/`sfpp1` aurora ports

> **Note:** The FPGA RTL files (`x300.v`, `bus_int.v`, Makefile, etc.) are not
> installed by `cmake --install`. They are used in-place from the source tree.
> Pass `-F /path/to/uhd/fpga` to `rfnoc_image_builder` to pick them up — see the
> rfnoc-oot-blocks patch repo for the full build command.
