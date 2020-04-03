//
// Created by miurahr on 2020/04/02.
//

#ifndef GDAL_CPL_SIMPLEJSON_H
#define GDAL_CPL_SIMPLEJSON_H

#include "cpl_string.h"

/************************************************************************/
/*                          ParseSimpleJson()                           */
/*                                                                      */
/*      Return a string list of name/value pairs extracted from a       */
/*      JSON doc.  The EC2 IAM web service returns simple JSON          */
/*      responses.  The parsing as done currently is very fragile       */
/*      and depends on JSON documents being in a very very simple       */
/*      form.                                                           */
/************************************************************************/

static CPLStringList ParseSimpleJson(const char *pszJson)

{
/* -------------------------------------------------------------------- */
/*      We are expecting simple documents like the following with no    */
/*      hierarchy or complex structure.                                 */
/* -------------------------------------------------------------------- */
/*
    {
    "Code" : "Success",
    "LastUpdated" : "2017-07-03T16:20:17Z",
    "Type" : "AWS-HMAC",
    "AccessKeyId" : "bla",
    "SecretAccessKey" : "bla",
    "Token" : "bla",
    "Expiration" : "2017-07-03T22:42:58Z"
    }
*/

    CPLStringList oWords(
            CSLTokenizeString2(pszJson, " \n\t,:{}", CSLT_HONOURSTRINGS ));
    CPLStringList oNameValue;

    for( int i=0; i < oWords.size(); i += 2 )
    {
        oNameValue.SetNameValue(oWords[i], oWords[i+1]);
    }

    return oNameValue;
}

#endif //GDAL_CPL_SIMPLEJSON_H
