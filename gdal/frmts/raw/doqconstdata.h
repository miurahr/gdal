//
// Created by miurahr on 2020/04/03.
//

#ifndef GDAL_DOQCONSTDATA_H
#define GDAL_DOQCONSTDATA_H

static const char UTM_FORMAT[] =
    "PROJCS[\"%s / UTM zone %dN\",GEOGCS[%s,PRIMEM[\"Greenwich\",0],"
    "UNIT[\"degree\",0.0174532925199433]],PROJECTION[\"Transverse_Mercator\"],"
    "PARAMETER[\"latitude_of_origin\",0],PARAMETER[\"central_meridian\",%d],"
    "PARAMETER[\"scale_factor\",0.9996],PARAMETER[\"false_easting\",500000],"
    "PARAMETER[\"false_northing\",0],%s]";

static const char WGS84_DATUM[] =
    "\"WGS 84\",DATUM[\"WGS_1984\",SPHEROID[\"WGS 84\",6378137,298.257223563]]";

static const char WGS72_DATUM[] =
    "\"WGS 72\",DATUM[\"WGS_1972\",SPHEROID[\"NWL 10D\",6378135,298.26]]";

static const char NAD27_DATUM[] =
    "\"NAD27\",DATUM[\"North_American_Datum_1927\","
    "SPHEROID[\"Clarke 1866\",6378206.4,294.978698213901]]";

static const char NAD83_DATUM[] =
    "\"NAD83\",DATUM[\"North_American_Datum_1983\","
    "SPHEROID[\"GRS 1980\",6378137,298.257222101]]";

#endif //GDAL_DOQCONSTDATA_H
