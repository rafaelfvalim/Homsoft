*&---------------------------------------------------------------------*
*& Report  ZHMS_CARGA_EV_VRS
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT  zhms_carga_tool.

DATA: itxls     TYPE STANDARD TABLE OF kcde_cells,
      waxls     TYPE kcde_cells.

DATA: lt_toolbar TYPE STANDARD TABLE OF zhms_tb_toolbar,
      ls_toolbar LIKE LINE OF lt_toolbar.

SELECTION-SCREEN BEGIN OF BLOCK b0 WITH FRAME TITLE text-001.
PARAMETERS:   parqv TYPE  rlgrap-filename OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b0.

INITIALIZATION.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR parqv.
  DATA: itfile  TYPE STANDARD TABLE OF ocs_f_info,
        wafile  TYPE ocs_f_info.

  CLEAR: parqv, itfile[], wafile.

  CALL FUNCTION 'OCS_FILENAME_GET'
    EXPORTING
      pi_def_filename  = ' '
      pi_def_path      = 'C:\'
      pi_mask          = ',*.xls,*.xlsx'
      pi_mode          = 'O'
      pi_title         = text-h03
    TABLES
      pt_fileinfo      = itfile
    EXCEPTIONS
      inv_winsys       = 1
      no_batch         = 2
      selection_cancel = 3
      selection_error  = 4
      general_error    = 5
      OTHERS           = 6.

  IF sy-subrc = 0.
    READ TABLE itfile INTO wafile INDEX 1.
    IF sy-subrc = 0.
      CONCATENATE wafile-file_path wafile-file_name INTO parqv.
    ENDIF.
  ENDIF.

START-OF-SELECTION.
  PERFORM carrega_arquivo.
  PERFORM insert_table.
*&---------------------------------------------------------------------*
*&      Form  CARREGA_ARQUIVO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM carrega_arquivo .

  REFRESH itxls[].
  CALL FUNCTION 'KCD_EXCEL_OLE_TO_INT_CONVERT'
    EXPORTING
      filename                = parqv
      i_begin_col             = '1'
      i_begin_row             = '1'
      i_end_col               = '100'
      i_end_row               = '9999'
    TABLES
      intern                  = itxls
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.

  IF sy-subrc IS NOT INITIAL.
    MESSAGE 'Erro ao carregar arquivo' TYPE 'I'.
    EXIT.
  ENDIF.

ENDFORM.                    " CARREGA_ARQUIVO
*&---------------------------------------------------------------------*
*&      Form  INSERT_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM insert_table .

  LOOP AT itxls INTO waxls.

    CASE waxls-col.
      WHEN '1'.
        MOVE waxls-value TO ls_toolbar-natdc.
      WHEN '2'.
        MOVE waxls-value TO ls_toolbar-typed.
      WHEN '3'.
        MOVE waxls-value TO ls_toolbar-scren.
      WHEN '4'.
        MOVE waxls-value TO ls_toolbar-fcode.
      WHEN '5'.
        MOVE waxls-value TO ls_toolbar-spras.

      WHEN '6'.
        MOVE waxls-value TO ls_toolbar-text.
      WHEN '7'.
        MOVE waxls-value TO ls_toolbar-bcode.
      WHEN '8'.
        MOVE waxls-value TO ls_toolbar-pcode.
      WHEN '9'.
        MOVE waxls-value TO ls_toolbar-icon.
        APPEND ls_toolbar TO lt_toolbar.
        CLEAR ls_toolbar.
    ENDCASE.

  ENDLOOP.

  IF sy-subrc IS INITIAL.
    MODIFY zhms_tb_toolbar FROM TABLE lt_toolbar.
    IF sy-subrc IS INITIAL.
      COMMIT WORK.
      MESSAGE 'Carga realizada com sucesso' TYPE 'S'.
    ELSE.
      MESSAGE 'Erro ao realizar a carga' TYPE 'E'.
    ENDIF.
  ENDIF.



ENDFORM.                    " INSERT_TABLE
