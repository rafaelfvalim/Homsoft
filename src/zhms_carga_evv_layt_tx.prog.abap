*&---------------------------------------------------------------------*
*& Report  ZHMS_CARGA_EV_VRS
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT  zhms_carga_evv_layt_tx.

DATA: itxls     TYPE STANDARD TABLE OF kcde_cells,
      waxls     TYPE kcde_cells.

DATA: BEGIN OF wa_data,
        line(500) TYPE c,
      END OF wa_data.

DATA: lt_data LIKE TABLE OF wa_data,
      filename TYPE string,
      con_tab  TYPE c VALUE cl_abap_char_utilities=>horizontal_tab.

DATA: lt_evv_layt_tx TYPE STANDARD TABLE OF zhms_tx_evv_layt,
      ls_evv_layt_tx LIKE LINE OF lt_evv_layt_tx.

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

*** Carrega TXT
  MOVE parqv TO filename.
  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename            = filename
      filetype            = 'ASC'
      has_field_separator = ' '
    TABLES
      data_tab            = lt_data.

  LOOP AT lt_data INTO wa_data.

    SPLIT wa_data AT con_tab INTO
                                  ls_evv_layt_tx-natdc
                                  ls_evv_layt_tx-typed
                                  ls_evv_layt_tx-loctp
                                  ls_evv_layt_tx-event
                                  ls_evv_layt_tx-versn
                                  ls_evv_layt_tx-codly
                                  ls_evv_layt_tx-spras
                                  ls_evv_layt_tx-denof.

    APPEND ls_evv_layt_tx TO lt_evv_layt_tx.
    CLEAR ls_evv_layt_tx.

  ENDLOOP.

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

  IF sy-subrc IS INITIAL.
    MODIFY zhms_tx_evv_layt FROM TABLE lt_evv_layt_tx.
    IF sy-subrc IS INITIAL.
      COMMIT WORK.
      MESSAGE 'Carga realizada com sucesso' TYPE 'S'.
    ELSE.
      MESSAGE 'Erro ao realizar a carga' TYPE 'E'.
    ENDIF.
  ENDIF.

ENDFORM.                    " INSERT_TABLE