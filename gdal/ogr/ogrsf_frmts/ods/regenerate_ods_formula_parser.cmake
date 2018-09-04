execute_process(COMMAND bison -p ods_formula -d -o${CMAKE_CURRENT_BINARY_DIR}/ods_formula_parser.cpp ${CMAKE_CURRENT_SOURCE_DIR}/ods_formula_parser.y
                WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
				ERROR_QUIET)
file(READ OFP_OUT ${CMAKE_CURRENT_BINARY_DIR}/ods_formula_parser.cpp)
# workaround bug with gcc 4.1 -O2
string(REPLACE "yytype_int16 yyssa[YYINITDEPTH];"
			   "yytype_int16 yyssa[YYINITDEPTH]; memset(yyssa, 0, sizeof(yyssa));"
			   OFP_OUT1 "${OFP_OUT}")
string(REPLACE "*yyssp = yystate" "*yyssp = (yytype_int16)yystate"
	   OFP_OUT2 "${OFP_OUT1}")
string(REPLACE "yyerrorlab:" "#if 0\nyyerrorlab:"
	   OFP_OUT3 "${OFP_OUT2}")
string(REPLACE "yyerrlab1:" "#endif\nyyerrlab1:"
	   OFP_OUT4 "${OFP_OUT3}")
string(REPLACE "YY_INITIAL_VALUE (static YYSTYPE yyval_default;)" ""
	   OFP_OUT5 "${OFP_OUT4}")
string(REPLACE "YYSTYPE yylval YY_INITIAL_VALUE (= yyval_default);" "YYSTYPE yylval = nullptr;"
	   OFP_OUT6 "${OFP_OUT5}")
file(WRITE ods_formula_parser.cpp "${OFP_OUT6}")
target_sources(ogr_ODS PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/ods_formula_parser.cpp)