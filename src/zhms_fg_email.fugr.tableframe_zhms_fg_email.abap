*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZHMS_FG_EMAIL
*   generation date: 13.12.2019 at 13:09:15
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZHMS_FG_EMAIL      .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
