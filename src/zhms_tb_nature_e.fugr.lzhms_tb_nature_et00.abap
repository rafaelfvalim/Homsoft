*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 18.10.2017 at 08:47:29
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZHMS_TB_NATURE_E................................*
DATA:  BEGIN OF STATUS_ZHMS_TB_NATURE_E              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZHMS_TB_NATURE_E              .
CONTROLS: TCTRL_ZHMS_TB_NATURE_E
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZHMS_TB_NATURE_E              .
TABLES: *ZHMS_TX_NATURE_E              .
TABLES: ZHMS_TB_NATURE_E               .
TABLES: ZHMS_TX_NATURE_E               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
