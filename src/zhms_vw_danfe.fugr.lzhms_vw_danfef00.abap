*---------------------------------------------------------------------*
*    view related FORM routines
*   generation date: 05.10.2018 at 06:44:47 by user DEVELOPER1
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZHMS_VW_DANFE...................................*
FORM GET_DATA_ZHMS_VW_DANFE.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZHMS_TB_DANFE WHERE
(VIM_WHERETAB) .
    CLEAR ZHMS_VW_DANFE .
ZHMS_VW_DANFE-MANDT =
ZHMS_TB_DANFE-MANDT .
ZHMS_VW_DANFE-TIPO =
ZHMS_TB_DANFE-TIPO .
ZHMS_VW_DANFE-DIRETORIO =
ZHMS_TB_DANFE-DIRETORIO .
<VIM_TOTAL_STRUC> = ZHMS_VW_DANFE.
    APPEND TOTAL.
  ENDSELECT.
  SORT TOTAL BY <VIM_XTOTAL_KEY>.
  <STATUS>-ALR_SORTED = 'R'.
*.check dynamic selectoptions (not in DDIC)...........................*
  IF X_HEADER-SELECTION NE SPACE.
    PERFORM CHECK_DYNAMIC_SELECT_OPTIONS.
  ELSEIF X_HEADER-DELMDTFLAG NE SPACE.
    PERFORM BUILD_MAINKEY_TAB.
  ENDIF.
  REFRESH EXTRACT.
ENDFORM.
*---------------------------------------------------------------------*
FORM DB_UPD_ZHMS_VW_DANFE .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZHMS_VW_DANFE.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZHMS_VW_DANFE-ST_DELETE EQ GELOESCHT.
     READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
     IF SY-SUBRC EQ 0.
       DELETE EXTRACT INDEX SY-TABIX.
     ENDIF.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN GELOESCHT.
  SELECT SINGLE FOR UPDATE * FROM ZHMS_TB_DANFE WHERE
  TIPO = ZHMS_VW_DANFE-TIPO .
    IF SY-SUBRC = 0.
    DELETE ZHMS_TB_DANFE .
    ENDIF.
    IF STATUS-DELETE EQ GELOESCHT.
      READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY> BINARY SEARCH.
      DELETE EXTRACT INDEX SY-TABIX.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN OTHERS.
  SELECT SINGLE FOR UPDATE * FROM ZHMS_TB_DANFE WHERE
  TIPO = ZHMS_VW_DANFE-TIPO .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZHMS_TB_DANFE.
    ENDIF.
ZHMS_TB_DANFE-MANDT =
ZHMS_VW_DANFE-MANDT .
ZHMS_TB_DANFE-TIPO =
ZHMS_VW_DANFE-TIPO .
ZHMS_TB_DANFE-DIRETORIO =
ZHMS_VW_DANFE-DIRETORIO .
    IF SY-SUBRC = 0.
    UPDATE ZHMS_TB_DANFE .
    ELSE.
    INSERT ZHMS_TB_DANFE .
    ENDIF.
    READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
    IF SY-SUBRC EQ 0.
      <XACT> = ORIGINAL.
      MODIFY EXTRACT INDEX SY-TABIX.
    ENDIF.
    <ACTION> = ORIGINAL.
    MODIFY TOTAL.
  ENDCASE.
ENDLOOP.
CLEAR: STATUS_ZHMS_VW_DANFE-UPD_FLAG,
STATUS_ZHMS_VW_DANFE-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZHMS_VW_DANFE.
  SELECT SINGLE * FROM ZHMS_TB_DANFE WHERE
TIPO = ZHMS_VW_DANFE-TIPO .
ZHMS_VW_DANFE-MANDT =
ZHMS_TB_DANFE-MANDT .
ZHMS_VW_DANFE-TIPO =
ZHMS_TB_DANFE-TIPO .
ZHMS_VW_DANFE-DIRETORIO =
ZHMS_TB_DANFE-DIRETORIO .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZHMS_VW_DANFE USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZHMS_VW_DANFE-TIPO TO
ZHMS_TB_DANFE-TIPO .
MOVE ZHMS_VW_DANFE-MANDT TO
ZHMS_TB_DANFE-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZHMS_TB_DANFE'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZHMS_TB_DANFE TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZHMS_TB_DANFE'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
