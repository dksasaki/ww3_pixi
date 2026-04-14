! -------------------------------------------------------------------- !
! WAVEWATCH III - ww3_prnc.nml - Field preprocessor                    !
! -------------------------------------------------------------------- !

&FORCING_NML
  FORCING%TIMESTART         = '20090930 234500'
  FORCING%TIMESTOP          = '20091231 235900'
  FORCING%FIELD%ICE_CONC    = T
  FORCING%GRID%LATLON       = T
/

&FILE_NML
  FILE%FILENAME      = 'ice.nc'
  FILE%LONGITUDE     = 'longitude'
  FILE%LATITUDE      = 'latitude'
  FILE%VAR(1)        = 'ICEC_surface'
/

! -------------------------------------------------------------------- !
! WAVEWATCH III - end of namelist                                      !
! -------------------------------------------------------------------- !