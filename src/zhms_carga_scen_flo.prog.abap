*&---------------------------------------------------------------------*
*& Report  ZHMS_CARGA_EV_VRS
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT  zhms_carga_scen_flo.

DATA: itxls     TYPE STANDARD TABLE OF kcde_cells,
      waxls     TYPE kcde_cells.

DATA: lt_scen_flo TYPE STANDARD TABLE OF zhms_tb_scen_flo,
      ls_scen_flo LIKE LINE OF lt_scen_flo.

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

  DATA: BEGIN OF wa_data,
          line(500) TYPE c,
        END OF wa_data.

  DATA: lt_data LIKE TABLE OF wa_data,
        filename TYPE string,
        con_tab  TYPE c VALUE cl_abap_char_utilities=>horizontal_tab,
        lv_tpprm TYPE n LENGTH 3.

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
                      ls_scen_flo-natdc
                      ls_scen_flo-typed
                      ls_scen_flo-loctp
                      ls_scen_flo-scena
                      ls_scen_flo-flowd
                      ls_scen_flo-metpr
                      lv_tpprm
                      ls_scen_flo-vldcd
                      ls_scen_flo-codmp
                      ls_scen_flo-funct
                      ls_scen_flo-event_c
                      ls_scen_flo-tcode
                      ls_scen_flo-mndoc
                      ls_scen_flo-mnyea
                      ls_scen_flo-tpadc
                      ls_scen_flo-tpaye
                      ls_scen_flo-codmp_estorno
                      ls_scen_flo-funct_estorno.

    MOVE lv_tpprm TO ls_scen_flo-tpprm.

    APPEND ls_scen_flo TO lt_scen_flo.
    CLEAR ls_scen_flo.

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
    MODIFY zhms_tb_scen_flo FROM TABLE lt_scen_flo.
    IF sy-subrc IS INITIAL.
      COMMIT WORK.
      MESSAGE 'Carga realizada com sucesso' TYPE 'S'.
    ELSE.
      MESSAGE 'Erro ao realizar a carga' TYPE 'E'.
    ENDIF.
  ENDIF.

ENDFORM.                    " INSERT_TABLE
