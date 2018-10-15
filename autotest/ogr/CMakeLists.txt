foreach(test_target IN ITEMS
        ogr_arcgen ogr_as_sqlite_extension ogr_avc ogr_basic_test ogr_bna ogr_cad ogr_carto ogr_cloudant
        ogr_couchdb ogr_csv ogr_csw ogr_db2 ogr_db2_hack ogr_dgn ogr_dgnv8 ogr_dods
        ogr_dxf ogr_edigeo ogr_eeda ogr_elasticsearch ogr_factory ogr_feature ogr_fgdb ogr_fgdb_stress_test
        ogr_geoconcept ogr_geojson ogr_geojsonseq ogr_geom ogr_georss ogr_geos ogr_gml_fgd_read
        ogr_gml_geom  ogr_gmt ogr_gpkg ogr_gpsbabel ogr_gpx ogr_grass
        ogr_gtm ogr_htf ogr_idrisi ogr_ili ogr_index_test ogr_ingres ogr_jml ogr_join_test
        ogr_kml ogr_layer_algebra ogr_libkml ogr_mem ogr_mitab ogr_mongodb ogr_mssqlspatial ogr_mvt
        ogr_mysql ogr_nas ogr_ntf ogr_odbc ogr_ods ogr_ogdi ogr_openair
        ogr_openfilegdb ogr_osm ogr_pcidsk ogr_pdf ogr_pds ogr_pg ogr_pgdump ogr_pgeo
        ogr_rec ogr_refcount ogr_rfc30 ogr_rfc35_mem ogr_rfc35_mitab ogr_rfc35_shape ogr_rfc35_sqlite
        ogr_rfc41 ogr_s57 ogr_sde ogr_sdts ogr_segukooa ogr_segy ogr_selafin
        ogr_shape_qix ogr_shape_sbn ogr_sosi ogr_sql_rfc28 ogr_sql_sqlite ogr_sql_test ogr_style
        ogr_sua ogr_svg ogr_sxf ogr_tiger ogr_vdv ogr_vfk ogr_virtualogr ogr_vrt
        ogr_wasp ogr_wfs ogr_wfs3 ogr_wkbwkt_geom ogr_wktempty ogr_xls ogr_xlsx ogr_xplane
        ograpi ogr_gft ogr_gml_read ogr_gmlas ogr_oci ogr_plscenes ogr_shape ogr_sqlite
       )
    add_test(${test_target} ${Python_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/${test_target}.py)
    set_property(TEST ${test_target} PROPERTY LABELS ogr-test)
    set_autotest_properties(TESTS ${test_target})
endforeach()
foreach(test_target IN ITEMS ogr_carto ogr_gft ogr_sql_sqlite ogr_gpkg ogr_gml_read ogr_gmlas ogr_libkml ogr_oci ogr_mitab ogr_plscenes ogr_shape ogr_sqlite)
    set_property(TEST ${test_target} PROPERTY TIMEOUT 20)
endforeach()
set_property(TEST ogr_gft PROPERTY TIMEOUT 30)
set_property(TEST ogr_cloudant PROPERTY TIMEOUT 30)
