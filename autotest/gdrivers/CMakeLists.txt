foreach(test_target IN ITEMS
        aaigrid ace2 adrg aigrid arg bag blx bsb
        bt byn cals ceos cpg ctg db2 derived
        dimap dipex dods doq1 doq2 dted e00grid ecrgtoc
        ecw eedai ehdr eir elas envi envisat ers
        fast fit fits fujibas gdalhttp genbin georaster gff
        gif gmt gpkg grass grassasciigrid grib gsc gsg
        gta gtx gxf hdf5 hf2 hfa ida idrisi
        ilwis ingr iris isce isis isis2 jdem jp2kak
        jp2lura jp2metadata jp2openjpeg jpeg jpeg2000 jpeg_profile jpegls jpipkak
        kea kmlsuperoverlay kro l1b lan lcp leveller loslas
        mbtiles mem mff mff2 mg4lidar mrf mrsid ndf
        netcdf netcdf_cf netcdf_cfchecks ngsgeoid nitf ntv1 ntv2 nwt_grc
        nwt_grd ozi paux pcidsk pcraster pdf pds pds4
        plmosaic png png_profile pnm postgisraster prf r rasdaman
        rasterlite rda rik rl2 rmf roipac rpftoc rraster
        rs2 safe saga sar_ceos sdts sentinel2 sgi sigdem
        snodas srp srtmhgt terragen test_validate_jp2 tiff_profile til usgsdem
        vicar vrtderived vrtfilt vrtlut vrtmask vrtovr vrtpansharpen vrtrawlink
        vrtwarp wcs webp wms wmts xmp xpm xyz
        zmap)
    add_test(gdriver_${test_target} ${Python_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/${test_target}.py)
    set_property(TEST gdriver_${test_target} PROPERTY LABELS gdrivers-test)
    set_autotest_properties(TESTS gdriver_${test_target})
endforeach()
foreach(test_target IN ITEMS gdalhttp georaster mbtiles wms dods gpkg jp2openjpeg nitf pdf pds4 rl2 rmf sentinel2 vrtderived wcs wmts)
    set_property(TEST gdriver_${test_target} PROPERTY TIMEOUT 20)
endforeach()
set_property(TEST gdriver_georaster PROPERTY TIMEOUT 40)
set_property(TEST gdriver_mrf PROPERTY TIMEOUT 30)
set_property(TEST gdriver_wms PROPERTY TIMEOUT 30)
