# WavewatchIII installation using pixi

Activate pixi with
```
pixi shell
```

Run the install script:

```
./install.sh
```

This will download WW3 from github and save it in the main directory we are working on.

## install.sh

building the file with install.sh will change the structure of WW3.

The switch files was obtained from WW3 file structure. Right now we are using ST6 + SNL1 (among other configurations)

```
WW3/
└── build/
    ├── switch                  ← copy of switch file
    ├── CMakeCache.txt
    ├── model/                  ← compiled objects, intermediate files
    └── install/                ← final installed files (DCMAKE_INSTALL_PREFIX=install)
        ├── bin/                ← executables (ww3_grid, ww3_shel, ww3_multi, etc.)
        └── lib/                ← libraries (if built)
```

# WW3 Executables

Preprocessing tools and ww3 executable are located in `WW3/build/bin`. Below is a not a list of the main files (not comprehensive)


| Executable | Usage |
|---|---|
| `ww3_grid` | Grid pre-processing. Runs first. Produces `mod_def.ww3`. |
| `ww3_prnc` | Pre-processes NetCDF forcing (wind, current, ice) into `.ww3` binaries. |
| `ww3_prep` | Same as `ww3_prnc` but for binary forcing inputs. |
| `ww3_shel` | Single-grid model run. |
| `ww3_multi` | Multi-grid run (nesting). Replaces `ww3_shel`. |
| `ww3_ounf` | Post-processes gridded output to NetCDF. |
| `ww3_ounp` | Post-processes point output (spectra, mean params) to NetCDF. |
| `ww3_bounc` | Generates spectral boundary conditions for a nested grid. |
| `ww3_trnc` | Truncates a restart file to a given time. |
| `ww3_uprstr` | Modifies fields inside a restart file. |


# WW3 Input Files

Each executable reads its corresponding input file (.nml or .inp) from the current working directory at runtime to configure its behaviour.

These files are found `WW3/model/inp` and `WW3/model/nml`.

| Input File | Executable | Format | Purpose |
|---|---|---|---|
| `ww3_grid.nml` | `ww3_grid` | `.nml` | Grid geometry, spectral discretization, timesteps, bathymetry/mask file paths |
| `ww3_prnc.nml` | `ww3_prnc` | `.nml` | NetCDF forcing variable mapping (field name, units, grid) |
| `ww3_prep.inp` | `ww3_prep` | `.inp` only | Binary forcing file paths and field type |
| `ww3_shel.nml` | `ww3_shel` | `.nml` | Run period, output times, output fields, forcing flags |
| `ww3_multi.nml` | `ww3_multi` | `.nml` | Grid list, nesting topology, run period, output fields |
| `ww3_ounf.nml` | `ww3_ounf` | `.nml` | Output time range, variables to extract, NetCDF version |
| `ww3_ounp.nml` | `ww3_ounp` | `.nml` | Point output type (spectra / mean params), time range, NetCDF version |
| `ww3_bounc.nml` | `ww3_bounc` | `.nml` | Source spectral file and target boundary definition |
| `ww3_trnc.nml` | `ww3_trnc` | `.nml` | Target truncation time for restart file |
| `ww3_uprstr.inp` | `ww3_uprstr` | `.inp` only | Field updates to apply to restart file |

