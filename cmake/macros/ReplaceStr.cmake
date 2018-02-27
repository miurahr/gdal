FILE(READ ${infile} f0)
STRING( REGEX REPLACE "${from}" "${to}" f1 "${f0}")
FILE(WRITE ${outfile} "${f1}")