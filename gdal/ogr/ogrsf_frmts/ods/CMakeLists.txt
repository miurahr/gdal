add_gdal_driver(TARGET ogr_ODS
			SOURCES ods_formula_node.cpp ods_formula_parser.cpp ods_formula_parser.hpp
            ods_formula.cpp ods_formula.h ogr_ods.h ogrodsdatasource.cpp ogrodsdriver.cpp)
gdal_standard_includes(ogr_ODS)
add_executable(testparser EXCLUDE_FROM_ALL testparser.cpp)

add_custom_command(OUTPUT ods_formula_parser.cpp
	COMMAND bison -p ods_formula -d -oods_formula_parser.cpp ods_formula_parser.y
	COMMAND sed "s/yytype_int16 yyssa\[YYINITDEPTH\];/yytype_int16 yyssa[YYINITDEPTH]; \/\* workaround bug with gcc 4.1 -O2 \*\/ memset(yyssa, 0, sizeof(yyssa));/" < ods_formula_parser.cpp | sed "s/\*yyssp = yystate/\*yyssp = (yytype_int16)yystate/" | sed "s/yyerrorlab:/#if 0\nyyerrorlab:/" | sed "s/yyerrlab1:/#endif\nyyerrlab1:/" | sed "s/YY_INITIAL_VALUE (static YYSTYPE yyval_default;)//" | sed "s/YYSTYPE yylval YY_INITIAL_VALUE (= yyval_default);/YYSTYPE yylval = nullptr;/" > ods_formula_parser.cpp.tmp
	COMMAND mv ods_formula_parser.cpp.tmp ods_formula_parser.cpp
)