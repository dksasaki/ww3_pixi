#!/bin/bash
# set -e

# WORKDIR='/home/otel/Doutorado/ww3/work/TUTORIAL/work2/work'
# EXE='../../../exe'
# cd "$WORKDIR"
echo "activate.sh loaded"

export PATH=$PATH:/home/otel/Desktop/deletar/ww3_pixi/WW3/build/bin

prepare_grid_nml() {
    local name=$1
    local n1=${name%%.*}
    cp ../input/ww3_grid.nml.$name ww3_grid.nml.$name
    ln -sf ww3_grid.nml.$name ww3_grid.nml
    ln -sf ../data_inp/$name.depth .
    ln -sf ../data_inp/$name.mask .
    ww3_grid | tee ww3_grid.$name.out
    mv mod_def.ww3 mod_def.$n1
    unlink ww3_grid.nml
}

prepare_grid_inp() {
    local name=$1
    local n1=${name%%.*}
    cp ../input/ww3_grid.inp.$name ww3_grid.inp.$name
    ln -sf ww3_grid.inp.$name ww3_grid.inp
    ww3_grid | tee ww3_grid.$name.out
    mv mod_def.ww3 mod_def.$n1
    unlink ww3_grid.inp
}


prepare_input_data_nml() {
    local name=$1
    ln -sf ../data_inp/$name.nc .

    ln -sf mod_def.$name mod_def.ww3
    cp ../input/ww3_prnc.nml.$name ww3_prnc.nml
    chmod +w ww3_prnc.nml
    ww3_prnc | tee ww3_prnc.$name.out
    mv $name.ww3 $name.$name
    unlink mod_def.ww3
}


prepare_input_data_inp() {
    local name=$1
    ln -sf ../data_inp/$name.nc .
    ln -sf mod_def.$name mod_def.ww3
    cp ../input/ww3_prnc.inp.$name ww3_prnc.inp
    chmod +w ww3_prnc.inp
    ww3_prnc | tee ww3_prnc.$name.out
    mv $name.ww3 $name.$name
    unlink mod_def.ww3
}

run_model_multi() {
    local name=$1 n=$2
    cp ../data_inp/points.list points.list
    cp ../input/ww3_multi.nml.$name ww3_multi.nml
    mpiexec -np $n ww3_multi
}

export_data_nc() {
    local name=$1
    ln -sf mod_def.$name  mod_def.ww3
    ln -sf out_grd.$name  out_grd.ww3
    cp ../input/ww3_ounf.nml.$name ww3_ounf.nml
    ww3_ounf
    unlink mod_def.ww3
}

export_data_pt() {
    local name=$1
    ln -sf mod_def.$name  mod_def.ww3
    ln -sf out_pnt.$name  out_pnt.ww3
    cp ../input/ww3_ounp.inp.$name ww3_ounp.inp
    ww3_ounp
    unlink mod_def.ww3
}

create_boundaries_unstr() {
    local name=$1
    ln -sf mod_def.$name mod_def.ww3
    cp ../input/ww3_bounc.nml.$name .
    ln -sf ww3_bounc.nml.$name ww3_bounc.nml
    ww3_bounc | tee ww3_bounc.out.$name
}

run_model_unstr() {
    local name=$1 n=$2
    cp ../input/ww3_shel.nml.$name ww3_shel.nml
    mpiexec -np $n ./ww3_shel
}

unlink_files() {
    unlink mod_def.ww3
    unlink ww3_prnc.nml
    rm -f wind.wind
}



export -f prepare_grid_inp
export -f prepare_grid_nml
export -f prepare_input_data_nml
export -f prepare_input_data_inp
export -f run_model_multi
export -f export_data_nc
export -f export_data_pt
export -f create_boundaries_unstr
export -f run_model_unstr
export -f unlink_files


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # --- main ---
    prepare_grid_nml global
    prepare_grid_nml southatl
    prepare_grid_nml wind
    prepare_grid_nml ice
    prepare_grid_inp points.global

    prepare_input_data_nml wind
    prepare_input_data_nml ice

    run_model_multi multi 20

    export_data_nc global
    export_data_nc southatl
    export_data_pt points

    mv glob*nc   ../output
    mv south*nc  ../output
    mv ww3.BOUND*nc ../boundary

    unlink_files

    prepare_grid saopaulo
    create_boundaries_unstr saopaulo
    prepare_grid saopaulo
    prepare_grid wind
    prepare_input_data wind
    ln -sf wind.wind wind.ww3
    run_model_unstr saopaulo 8

    export_data_nc saopaulo
fi
