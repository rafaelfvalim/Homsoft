*----------------------------------------------------------------------*
*                      H  o  m  S  o  f  t                             *
*          Gestão Eletrônica de Documentos e Processos                 *
*----------------------------------------------------------------------*
* Descrição: Monitor Central de Gerenciamento de Documentos            *
*            Declarações Globais                                       *
*----------------------------------------------------------------------*
    FUNCTION-POOL zhms_fg_monitor MESSAGE-ID zhms_mc_monitor.

    CONSTANTS:
      BEGIN OF c_nodekey,
        root    TYPE tv_nodekey VALUE 'Root',               "#EC NOTEXT
        child   TYPE tv_nodekey VALUE 'Child1',             "#EC NOTEXT
        child2  TYPE tv_nodekey VALUE 'Child2',             "#EC NOTEXT
      END OF c_nodekey.

*----------------------------------------------------------------------*
*       CLASS LCL_APPLICATION DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
    CLASS lcl_application DEFINITION.

      PUBLIC SECTION.
        METHODS:
          handle_button_click
            FOR EVENT button_click
            OF cl_gui_column_tree
            IMPORTING node_key item_name,
          handle_link_click
            FOR EVENT link_click
            OF cl_gui_column_tree
            IMPORTING node_key item_name.
    ENDCLASS.                    "LCL_APPLICATION DEFINITION
*** ---------------------------------------------------------------- ***
*** Classes Locais: SAP Evento HTML
*** ---------------------------------------------------------------- ***
    CLASS lcl_event_handler DEFINITION.
      PUBLIC SECTION.
        METHODS on_sapevent FOR EVENT sapevent OF cl_gui_html_viewer
                            IMPORTING action
                                      frame
                                      getdata
                                      postdata
                                      query_table.
    ENDCLASS.               "LCL_EVENT_HANDLER

*** ---------------------------------------------------------------- ***
*** Classes Locais: HTML Script's
*** ---------------------------------------------------------------- ***
    CLASS lcl_html_script DEFINITION INHERITING FROM cl_gui_html_viewer.
      PUBLIC SECTION.
***     Método Construtor
        METHODS constructor
                  IMPORTING
                    value(parent) TYPE REF TO cl_gui_container
                  EXCEPTIONS
                    cntl_error.

***     Executo de JavaScript por Demanda
        METHODS run_script_on_demand
                  IMPORTING
                    value(script) TYPE STANDARD TABLE.

***     Gerador de Documentos
        METHODS load_bds_doc
                  IMPORTING
                    value(doc_name)        TYPE c
                    value(doc_langu)       TYPE c OPTIONAL
                    value(doc_description) TYPE c OPTIONAL
                    value(bds_objectkey)   TYPE c
                    !value(bds_classname)  TYPE c DEFAULT 'SAPHTML'
                    !value(bds_classtyp)   TYPE c DEFAULT 'OT'
                  EXPORTING
                    value(assigned_url)    TYPE c.

***     Gerador de Ícones
        METHODS load_bds_icon
                  IMPORTING
                    value(icon_name) TYPE iconname
                  EXPORTING
                    value(assigned_url) TYPE c
                    value(file_name)    TYPE c.
    ENDCLASS.                    "lcl_html_script DEFINITION

*-----------------------------------------------*
* CLASS lcl_receiver DEFINITION
*-----------------------------------------------*
* Timer para atualização do monitor
*-----------------------------------------------*
    CLASS lcl_receiver DEFINITION.
      PUBLIC SECTION.
        METHODS:
        handle_finished FOR EVENT finished OF cl_gui_timer.

        METHODS :
            handel_hotspot_click
              FOR EVENT hotspot_click OF cl_gui_alv_grid
              IMPORTING e_row_id e_column_id.

    ENDCLASS.                    "lcl_receiver DEFINITION

*-----------------------------------------------*
* Classes para Visualização de XML em Árvore
*-----------------------------------------------*
    CLASS cl_gui_column_tree DEFINITION LOAD.
    CLASS cl_gui_cfw         DEFINITION LOAD.

*----------------------------------------------------------------------*
*   CLASS cl_app_toolbar DEFINITION
*----------------------------------------------------------------------*
*   Definição da Classe para TOOLBAR
*----------------------------------------------------------------------*
    CLASS cl_app_toolbar DEFINITION.
      PUBLIC SECTION.
        CLASS-METHODS: on_function_selected
                       FOR EVENT function_selected OF cl_gui_toolbar
                       IMPORTING fcode.
    ENDCLASS.                    " cl_app_toolbar DEFINITION

*----------------------------------------------------------------------*
*   CLASS lcl_tree_event_receiver DEFINITION
*----------------------------------------------------------------------*
*   Definição da Classe handle para Tree de atribuição
*----------------------------------------------------------------------*
    CLASS lcl_tree_event_receiver DEFINITION.

      PUBLIC SECTION.

        METHODS handle_item_double_click
          FOR EVENT item_double_click OF cl_gui_alv_tree
          IMPORTING node_key
                    fieldname.

    ENDCLASS.                    "lcl_tree_event_receiver DEFINITION

*----------------------------------------------------------------------*
*   CLASS lcl_vld_event_receiver DEFINITION
*----------------------------------------------------------------------*
*   Definição da Classe handle para Tree de atribuição
*----------------------------------------------------------------------*
    CLASS lcl_vld_event_receiver DEFINITION.

      PUBLIC SECTION.

        METHODS handle_item_double_click
          FOR EVENT item_double_click OF cl_gui_alv_tree
          IMPORTING node_key
                    fieldname.

    ENDCLASS.                    "lcl_vld_event_receiver DEFINITION

*** ---------------------------------------------------------------- ***
*** Constantes
*** ---------------------------------------------------------------- ***

*** ---------------------------------------------------------------- ***
*** Estruturas
*** ---------------------------------------------------------------- ***
    TYPES: BEGIN OF ty_tabs.
            INCLUDE STRUCTURE rsdstabs.
    TYPES: END OF ty_tabs.

    TYPES: BEGIN OF ty_flds.
            INCLUDE STRUCTURE rsdsfields.
    TYPES: END OF ty_flds.

    TYPES: html_dso_line(250) TYPE c.

    TYPES: node_table_type LIKE STANDARD TABLE OF mtreesnode WITH DEFAULT KEY,
           item_table_type LIKE STANDARD TABLE OF mtreeitm   WITH DEFAULT KEY.

    TYPES: BEGIN OF ty_logdoc,
            check TYPE flag,
            icon  TYPE icon_d,
            ltext TYPE zhms_de_ltext.
            INCLUDE STRUCTURE zhms_tb_logdoc.
    TYPES: END OF ty_logdoc.

    TYPES: BEGIN OF ty_hrvalid,
            icon  TYPE icon_d,
            ltext TYPE zhms_de_ltext,
            isgrp TYPE zhms_de_isgrp,
            grpcd TYPE zhms_de_grpcd.
            INCLUDE STRUCTURE zhms_tb_hrvalid.
    TYPES: END OF ty_hrvalid.

    TYPES: BEGIN OF ty_docrcbto,
            check TYPE flag,
            icon  TYPE icon_d.
            INCLUDE STRUCTURE zhms_tb_docrcbto.
    TYPES: END OF ty_docrcbto.

    TYPES: BEGIN OF ty_docconf,
            check TYPE flag,
            icon  TYPE icon_d.
            INCLUDE STRUCTURE zhms_tb_docconf.
    TYPES: END OF ty_docconf.

    TYPES: BEGIN OF ty_datconf,
            dcitm TYPE zhms_de_dcitm,
            cfqtd TYPE zhms_de_cfqtd,
            charg TYPE zhms_de_charg,
            denom	TYPE zhms_de_denom,
            dcqtd	TYPE zhms_de_dcqtd,
            dcunm	TYPE zhms_de_dcunm,
           END OF ty_datconf.

    TYPES: BEGIN OF ty_itmatr,
            check TYPE flag,
            icon  TYPE icon_d,
            ncm   TYPE zhms_de_ncm,
            lotemigo  TYPE charg_d.
            INCLUDE STRUCTURE zhms_tb_itmatr.
    TYPES: END OF ty_itmatr.
*
*    TYPES: BEGIN OF ty_flwdoc,
*            check TYPE flag,
*            icon  TYPE icon_d,
*            denom  TYPE zhms_de_denom.
*            INCLUDE STRUCTURE zhms_tb_flwdoc.
*    TYPES: END OF ty_flwdoc.

    TYPES: BEGIN OF ty_atrbuffer,
            field TYPE zhms_de_mneum,
            sumat TYPE zhms_de_usprc,
           END OF ty_atrbuffer.

    TYPES: BEGIN OF ty_logparam,
           datade   TYPE dats,
           dataate  TYPE dats,
           lote     TYPE zhms_de_lote,
           END OF ty_logparam.

    TYPES: BEGIN OF ty_logunk,
      detal TYPE icon,
      lote  TYPE zhms_de_lote,
      nrmsg	TYPE zhms_de_nrmsg,
      exnat	TYPE zhms_de_exnat,
      extpd	TYPE zhms_de_extpd,
      mensg	TYPE zhms_de_mensg,
      exevt	TYPE zhms_de_exevt,
      descr TYPE zhms_de_denom,
      direc	TYPE zhms_de_direc,
      seqnc	TYPE zhms_de_seqnc,
      erro  TYPE zhms_de_erro,
      dtalt	TYPE zhms_de_dtalt,
      hralt	TYPE zhms_de_hralt,
      usuar	TYPE uname,
      mark(1) TYPE c,
      event	TYPE zhms_de_event,
      natdc	TYPE zhms_de_natdc,
      typed	TYPE zhms_de_typed,
      END OF ty_logunk.

    TYPES: BEGIN OF ty_logdetal,
      lote  TYPE zhms_de_lote,
      tipo(3)  TYPE c,
      seqnc TYPE zhms_de_seqnc,
      dcitm TYPE zhms_de_dcitm,
      field TYPE zhms_de_field,
      value TYPE zhms_de_value,
    END OF ty_logdetal.

    TYPES: BEGIN OF ty_ht_evt,
      natdc   TYPE char30,
      typed   TYPE zhms_de_typed,
      event   TYPE char50,
      tpeve   TYPE zhms_de_tpeve,
      nseqev  TYPE zhms_de_nseqev,
      lote    TYPE zhms_de_lote,
      xmotivo TYPE zhms_de_xmoti,
      dthrreg TYPE zhms_de_dheve,
      protoco TYPE zhms_de_proto,
      dataenv TYPE zhms_de_datae,
      horaenv TYPE zhms_de_horae,
      usuario TYPE uname,
    END OF ty_ht_evt.

    TYPES: BEGIN OF ty_alv_audi,
      item        TYPE c LENGTH 5,
      desc        TYPE c LENGTH 255,
      unidade     TYPE c LENGTH 10,
      qtde        TYPE c LENGTH 10,
      vprod       TYPE c LENGTH 10,
      picms       TYPE c LENGTH 8,
      vicms       TYPE c LENGTH 8,
      pipi        TYPE c LENGTH 8,
      vipi        TYPE c LENGTH 8,
      ppis        TYPE c LENGTH 8,
      vpis        TYPE c LENGTH 8,
      pcofins     TYPE c LENGTH 8,
      vcofins     TYPE c LENGTH 8,
           END OF ty_alv_audi,

           BEGIN OF ty_alv_ped_xml,
      item        TYPE c LENGTH 5,
      impo        TYPE c LENGTH 10,
      baseped     TYPE c LENGTH 8,
      valor       TYPE c LENGTH 60, "wemng,
      basexml     TYPE c LENGTH 8,
      valor2      TYPE c LENGTH 10, "wemng,
      farol       TYPE c,
      unit_ped    TYPE ekpo-netwr,
      unit_xml    TYPE ekpo-netwr,
           END OF ty_alv_ped_xml.

    DATA:   node       TYPE treev_node,
            item       TYPE mtreeitm.

*** ---------------------------------------------------------------- ***
*** Tabelas Internas
*** ---------------------------------------------------------------- ***
    DATA: t_events      TYPE cntl_simple_events,
          t_html_index  TYPE w3htmltab,
          t_param       TYPE STANDARD TABLE OF zhms_st_html_param,
          t_lfa1        TYPE STANDARD TABLE OF lfa1,
          t_kna1        TYPE STANDARD TABLE OF kna1,
          t_docst	      TYPE STANDARD TABLE OF zhms_tb_docst,
          t_docst_new   TYPE STANDARD TABLE OF zhms_tb_docst,
          t_docrf	      TYPE STANDARD TABLE OF zhms_tb_docrf,
          t_docrf_es    TYPE STANDARD TABLE OF zhms_es_docrf,
          t_srscd       TYPE STANDARD TABLE OF zhms_st_html_srscd,
          t_srscd_ev    TYPE w3htmltab,
          t_nature      TYPE STANDARD TABLE OF zhms_tb_nature,
          t_nature_t    TYPE STANDARD TABLE OF zhms_tx_nature,
          t_type        TYPE STANDARD TABLE OF zhms_tb_type,
          t_type_t      TYPE STANDARD TABLE OF zhms_tx_type,
          t_grpfld_s    TYPE STANDARD TABLE OF zhms_tb_grpfld_s,
          t_index       TYPE STANDARD TABLE OF zhms_st_html_index,
          t_cabdoc      TYPE STANDARD TABLE OF zhms_tb_cabdoc,
          t_cabdoc_ref  TYPE STANDARD TABLE OF zhms_tb_cabdoc,
          t_codes       TYPE TABLE OF sy-ucomm,
          t_tabs        TYPE TABLE OF ty_tabs,
          t_flds        TYPE TABLE OF ty_flds,
          t_datasrc     TYPE TABLE OF html_dso_line INITIAL SIZE 20,
          t_wwwdata     TYPE TABLE OF wwwdata,
          t_repdoc      TYPE TABLE OF zhms_tb_repdoc,
          t_xmlview     TYPE TABLE OF zhms_es_xmlview,
          t_xmlview_aux TYPE TABLE OF zhms_es_xmlview,
          t_itensview   TYPE TABLE OF zhms_es_itmview,
          t_itensvld    TYPE TABLE OF ty_hrvalid,
          t_itmdoc      TYPE TABLE OF zhms_tb_itmdoc,
          t_itmatr      TYPE TABLE OF zhms_tb_itmatr,
          t_itmdoc_atr  TYPE TABLE OF zhms_tb_itmdoc,
          t_itmatr_atr  TYPE TABLE OF zhms_tb_itmatr,
          t_itmatr_ax   TYPE TABLE OF ty_itmatr,
*Homine - Inicio da Inclusão - DD - Ajuste Atribuição
          t_itmatr_ex   TYPE TABLE OF ty_itmatr,
*Homine - Fim da Inclusão - DD - Ajuste Atribuição
          t_node_tree   TYPE treev_ntab,
          t_item_tree   TYPE item_table_type,
          tl_textnote(72) TYPE c OCCURS 0,
          t_texpr       TYPE rsds_texpr,
          t_twhere      TYPE rsds_twhere,
          t_logdoc_aux  TYPE TABLE OF ty_logdoc,
          t_logdoc      TYPE TABLE OF zhms_tb_logdoc,
          t_hvalid_aux  TYPE TABLE OF zhms_es_hvalid,
          t_hvalid_aux2 TYPE TABLE OF zhms_es_hvalid,
          t_hvalid_vw   TYPE TABLE OF zhms_es_hvalid,
          t_hrvalid_aux TYPE TABLE OF ty_hrvalid,
          t_hrvalid     TYPE TABLE OF zhms_tb_hrvalid,
          t_hvalid      TYPE TABLE OF zhms_tb_hvalid,
          t_regvld      TYPE TABLE OF zhms_tb_regvld,
          t_regvldx     TYPE TABLE OF zhms_tx_regvld,
          t_sort_hvalid TYPE lvc_t_sort WITH HEADER LINE,
          t_hvalid_fldc TYPE lvc_t_fcat,
          t_flow_fldc   TYPE lvc_t_fcat,
          t_vld_fldc    TYPE lvc_t_fcat,
          t_fieldcat    TYPE lvc_t_fcat,
          t_fieldcatitm TYPE lvc_t_fcat,
          t_fieldcatvld TYPE lvc_t_fcat,
          t_bapireturn  TYPE TABLE OF bapiret2,
          t_evv_laytx   TYPE TABLE OF zhms_tx_evv_layt,
          t_evv_layt    TYPE TABLE OF zhms_tb_evv_layt,
          t_btnmnu      TYPE ttb_btnmnu,
          t_buttons     TYPE ttb_button,
          t_toolbar     TYPE STANDARD TABLE OF zhms_tb_toolbar,
          t_toolbar_aux TYPE STANDARD TABLE OF zhms_tb_toolbar,
          t_chave       TYPE TABLE OF zhms_tb_cabdoc-chave,
          t_gatemneu    TYPE TABLE OF zhms_tb_gatemneu,
          t_gatemneux   TYPE TABLE OF zhms_tx_gatemneu,
          t_gateobs     TYPE TABLE OF zhms_tb_gateobs,
          t_docrcbto_ax TYPE TABLE OF ty_docrcbto,
          t_docconf_ax  TYPE TABLE OF ty_docconf,
          t_docrcbto    TYPE TABLE OF zhms_tb_docrcbto,
          t_datrcbto    TYPE TABLE OF zhms_tb_datrcbto,
          t_docconf     TYPE TABLE OF zhms_tb_docconf,
          t_datconf     TYPE TABLE OF zhms_tb_datconf,
          t_datconf_ax  TYPE TABLE OF ty_datconf,
          t_dcevet      TYPE TABLE OF zhms_tb_dcevet,
          t_nfeevt      TYPE TABLE OF zhms_tb_nfeevt,
          t_flwdoc      TYPE TABLE OF zhms_tb_flwdoc,
          t_flwdoc_ax   TYPE TABLE OF zhms_es_flwdoc, "ty_flwdoc,
          t_flwdoc_ax2  TYPE TABLE OF zhms_es_flwdoc, "ty_flwdoc,
          t_scenflox    TYPE TABLE OF zhms_tx_scen_flo,
          t_scenflo     TYPE TABLE OF zhms_tb_scen_flo,
          t_docmn       TYPE TABLE OF zhms_tb_docmn,
          t_docmnxped   TYPE TABLE OF zhms_tb_docmn,
          t_docmna       TYPE TABLE OF zhms_tb_docmn,
          t_docmn_rep   TYPE TABLE OF zhms_tb_docmn,
          t_docmn_ax    TYPE TABLE OF zhms_tb_docmn,
          t_atrbuffer   TYPE TABLE OF ty_atrbuffer,
          t_mneuatr     TYPE TABLE OF zhms_tb_mneuatr,
          t_vld_item    TYPE STANDARD TABLE OF zhms_tb_vld_item,
          t_vld_itemx   TYPE STANDARD TABLE OF zhms_es_vld_item,
          t_es_vld_h    TYPE STANDARD TABLE OF zhms_es_vld_h,
          t_es_vld_i    TYPE STANDARD TABLE OF zhms_es_vld_i,
          t_out_vld_i   TYPE STANDARD TABLE OF zhms_es_vld_i,
          t_logunk      TYPE TABLE OF ty_logunk,
          t_msgunk      TYPE STANDARD TABLE OF zhms_tb_msgunk,
          t_msgunka     TYPE STANDARD TABLE OF zhms_tb_msgunka,
          t_logparam    TYPE TABLE OF ty_logparam,
          t_logdetal    TYPE TABLE OF ty_logdetal,
          t_ht_field    TYPE lvc_t_fcat,
          t_ht_field2   TYPE lvc_t_fcat,
          t_ht_field3   TYPE lvc_t_fcat,
          t_ht_histo    TYPE STANDARD TABLE OF zhms_tb_histev,
          t_ht_out      TYPE STANDARD TABLE OF ty_ht_evt,
          t_tx_events   TYPE STANDARD TABLE OF zhms_tx_events,
          t_show_po     TYPE STANDARD TABLE OF zhms_es_show_poss_po,
          gt_bdc        LIKE bdcdata    OCCURS 0 WITH HEADER LINE,
          t_impostos    TYPE STANDARD TABLE OF bapi_j_1bnfstx,
          t_j1b1n_tax   TYPE STANDARD TABLE OF j_1bdystx,
          lt_mapdata    TYPE STANDARD TABLE OF zhms_tb_mapdata,
          it_docmn_danfe TYPE TABLE OF zhms_tb_docmn,
          t_alv_xml     TYPE TABLE OF ty_alv_audi,
          t_alv_ped     TYPE TABLE OF ty_alv_ped_xml,
          t_alv_ped_aux TYPE TABLE OF ty_alv_ped_xml,
          t_alv_comp    TYPE TABLE OF ty_alv_ped_xml,
          t_alv_comp_au TYPE TABLE OF ty_alv_ped_xml,
          lt_message    TYPE bdcmsgcoll OCCURS 0 WITH HEADER LINE.

    DATA l_ex_ref TYPE REF TO cx_root.
    DATA opt      TYPE ctu_params.
    DATA: tl_itxw_note    TYPE STANDARD TABLE OF txw_note,
          wl_itxw_note    TYPE txw_note.
*** ---------------------------------------------------------------- ***
*** Áreas de Trabalho
*** ---------------------------------------------------------------- ***
    DATA: wa_event         TYPE cntl_simple_event,
          wa_docmn_rep     TYPE zhms_tb_docmn,
          wa_impostos      TYPE bapi_j_1bnfstx,
          ls_mapping       TYPE zhms_tb_mapping,
          wa_j1b1n_tax     LIKE LINE OF t_j1b1n_tax,
          wa_param         TYPE zhms_st_html_param,
          wa_lfa1          TYPE lfa1,
          wa_docmnxped     TYPE zhms_tb_docmn,
          wa_docmna        TYPE zhms_tb_docmn,
          ls_mapdata       LIKE LINE OF lt_mapdata,
          wa_kna1          TYPE kna1,
          wa_docst         TYPE zhms_tb_docst,
          wa_flds          TYPE ty_flds,
          wa_tabs          TYPE ty_tabs,
          wa_docst_new     TYPE zhms_tb_docst,
          wa_docrf         TYPE zhms_tb_docrf,
          wa_docrf_es      TYPE zhms_es_docrf,
          wa_srscd         TYPE zhms_st_html_srscd,
          wa_nature        TYPE zhms_tb_nature,
          wa_nature_t      TYPE zhms_tx_nature,
          wa_type          TYPE zhms_tb_type,
          wa_type_t        TYPE zhms_tx_type,
          wa_grpfld_s      TYPE zhms_tb_grpfld_s,
          wa_index         TYPE zhms_st_html_index,
          wa_cabdoc        TYPE zhms_tb_cabdoc,
          wa_cabdoc_main   TYPE zhms_tb_cabdoc,
          wa_datasrc       TYPE html_dso_line,
          wa_wwwdata       TYPE wwwdata,
          wa_repdoc        TYPE zhms_tb_repdoc,
          wa_xmlview       TYPE zhms_es_xmlview,
          wa_xmlview_aux   TYPE zhms_es_xmlview,
          wa_itensview     TYPE zhms_es_itmview,
          wa_itmdoc        TYPE zhms_tb_itmdoc,
          wa_itmdoc_ax     TYPE zhms_tb_itmdoc,
          wa_itmatr        TYPE zhms_tb_itmatr,
          wa_itmatr_ax     TYPE ty_itmatr,
*Homine - Inicio da Inclusão - DD - Ajuste Atribuição
          wa_itmatr_ex     TYPE ty_itmatr,
*Homine - Fim da Inclusão - DD - Ajuste Atribuição
          wa_logdoc_aux    TYPE ty_logdoc,
          wa_logdoc        TYPE zhms_tb_logdoc,
          wa_hvalid_aux    TYPE zhms_es_hvalid,
          wa_hvalid_vw     TYPE zhms_es_hvalid,
          wa_hrvalid_aux   TYPE ty_hrvalid,
          wa_hrvalid_aux2  TYPE ty_hrvalid,
          wa_itensview_vld TYPE ty_hrvalid,
          wa_just          TYPE zhms_tb_justific,
          wa_hrvalid       TYPE zhms_tb_hrvalid,
          wa_hvalid        TYPE zhms_tb_hvalid,
          wa_lt_vld_hvalid TYPE lvc_s_layo,
          wa_hvalid_fldc   TYPE lvc_s_fcat,
          wa_flow_fldc     TYPE lvc_s_fcat,
          wa_vld_fldc      TYPE lvc_s_fcat,
          wa_fieldcat      TYPE lvc_s_fcat,
          wa_fieldcatvld   TYPE lvc_s_fcat,
          wa_hier_header   TYPE treev_hhdr,
          wa_variant       TYPE disvariant,
          wa_vld_usrad     TYPE bapiaddr3,
          wa_bapireturn    TYPE bapiret2,
          wa_evv_laytx     TYPE zhms_tx_evv_layt,
          wa_evv_layt      TYPE zhms_tb_evv_layt,
          wa_btnmnu        TYPE LINE OF ttb_btnmnu,
          wa_buttons       TYPE LINE OF ttb_button,
          wa_toolbar       TYPE zhms_tb_toolbar,
          wa_toolbar_aux   TYPE zhms_tb_toolbar,
          wa_hvalid_new    TYPE zhms_tb_hvalid,
          wa_gate          TYPE zhms_tb_gate,
          wa_gatemneu      TYPE zhms_tb_gatemneu,
          wa_gatemneux     TYPE zhms_tx_gatemneu,
          wa_gateobs       TYPE zhms_tb_gateobs,
          wa_docrcbto_ax   TYPE ty_docrcbto,
          wa_docconf_ax    TYPE ty_docconf,
          wa_docrcbto      TYPE zhms_tb_docrcbto,
          wa_datrcbto      TYPE zhms_tb_datrcbto,
          wa_docconf       TYPE zhms_tb_docconf,
          wa_datconf       TYPE zhms_tb_datconf,
          wa_datconf_ax    TYPE ty_datconf,
          wa_return        TYPE zhms_es_return,
          wa_dcevet        TYPE zhms_tb_dcevet,
          wa_nfeevt        TYPE zhms_tb_nfeevt,
          wa_regvld        TYPE zhms_tb_regvld,
          wa_regvldx       TYPE zhms_tx_regvld,
          wa_flwdoc        TYPE zhms_tb_flwdoc,
          wa_flwdoc_ax     TYPE zhms_es_flwdoc, "ty_flwdoc,
          wa_scenflox      TYPE zhms_tx_scen_flo,
          wa_scenflo       TYPE zhms_tb_scen_flo,
          wa_docmn         TYPE zhms_tb_docmn,
          wa_docmnx       TYPE zhms_tb_docmn,
          wa_docmn_ax      TYPE zhms_tb_docmn,
          wa_atrbuffer     TYPE ty_atrbuffer,
          wa_mneuatr       TYPE zhms_tb_mneuatr,
          wa_chave         TYPE zhms_tb_cabdoc-chave,
          wa_vld_item      LIKE LINE OF t_vld_item,
          wa_twhere        LIKE LINE OF t_twhere,
          wa_vld_itemx     LIKE LINE OF t_vld_itemx,
          wa_es_vld_h      LIKE LINE OF t_es_vld_h,
          wa_es_vld_i      TYPE zhms_es_vld_i,
          wa_out_vld_i     LIKE LINE OF t_out_vld_i,
          wa_logunk        LIKE LINE OF t_logunk,
          wa_logunkaux     LIKE LINE OF t_logunk,
          wa_logparam      LIKE LINE OF t_logparam,
          wa_logdetal      LIKE LINE OF t_logdetal,
          wa_ht_field      LIKE LINE OF t_ht_field,
          wa_ht_histo      LIKE LINE OF t_ht_histo,
          wa_ht_out        LIKE LINE OF t_ht_out,
          wa_tx_events     LIKE LINE OF t_tx_events,
          wa_docstx        TYPE zhms_tb_docst,
          wa_show_po       LIKE LINE OF t_show_po,
          wa_1bdylin       TYPE j_1bdylin,
          wa_docmn_danfe   TYPE zhms_tb_docmn,
          wa_alv_xml       TYPE ty_alv_audi,
          wa_alv_ped       TYPE ty_alv_ped_xml,
          wa_alv_comp      TYPE ty_alv_ped_xml,
          wa_message       TYPE bdcmsgcoll.

*** ---------------------------------------------------------------- ***
*** Objetos
*** ---------------------------------------------------------------- ***
    DATA: ob_cc_logotipo   TYPE REF TO cl_gui_custom_container,
          ob_logotipo      TYPE REF TO cl_gui_picture,
          ob_cc_img_docs   TYPE REF TO cl_gui_custom_container,
          ob_img_docs      TYPE REF TO cl_gui_picture,
          ob_cc_html_index TYPE REF TO cl_gui_custom_container,
          ob_html_index    TYPE REF TO cl_gui_html_viewer,
          ob_cc_html_docs  TYPE REF TO cl_gui_custom_container,
          ob_html_docs     TYPE REF TO lcl_html_script,
          ob_cc_html_det   TYPE REF TO cl_gui_custom_container,
          ob_html_det      TYPE REF TO lcl_html_script,
          ob_cc_html_rcp   TYPE REF TO cl_gui_custom_container,
          ob_html_rcp      TYPE REF TO lcl_html_script,
          ob_cc_pdf_docs   TYPE REF TO cl_gui_custom_container,
          ob_pdf_docs      TYPE REF TO cl_gui_html_viewer,

          ob_cc_xml_docs   TYPE REF TO cl_gui_custom_container,
          ob_xml_docs      TYPE REF TO cl_gui_alv_tree,
          ob_cc_vis_itens  TYPE REF TO cl_gui_custom_container,
          ob_vis_itens     TYPE REF TO cl_gui_alv_tree,
          ob_cc_atr_itens  TYPE REF TO cl_gui_custom_container,
          ob_atr_itens     TYPE REF TO cl_gui_alv_tree,

          ob_valid         TYPE REF TO cl_gui_column_tree,
          ob_cc_valid      TYPE REF TO cl_gui_custom_container,

*** Inicio inclusão David Rosin 11/2014
          ob_tree_valid      TYPE REF TO cl_gui_alv_tree,
          ob_cc_valid_itens  TYPE REF TO cl_gui_custom_container,
*** Fim Inclusão David Rosin 11/2014

          ob_cc_tb_docs    TYPE REF TO cl_gui_custom_container,
          ob_tb_docs       TYPE REF TO cl_gui_toolbar,
          ob_menu_docs     TYPE REF TO cl_ctmenu,
          ob_cc_tb_det     TYPE REF TO cl_gui_custom_container,
          ob_tb_det        TYPE REF TO cl_gui_toolbar,
          ob_menu_det      TYPE REF TO cl_ctmenu,

          ob_receiver      TYPE REF TO lcl_event_handler,
          ob_timer         TYPE REF TO cl_gui_timer,
          ob_timer_event   TYPE REF TO lcl_receiver,
          ob_cc_vld_hvalid TYPE REF TO cl_gui_custom_container,
          ob_hvalid        TYPE REF TO cl_gui_alv_tree,
          ob_flow          TYPE REF TO cl_gui_column_tree,
          ob_hvalid_event  TYPE REF TO lcl_receiver,
          ob_ref_consumer  TYPE REF TO cl_gui_props_consumer,
          ob_dcevt_obs     TYPE REF TO cl_gui_textedit,
          ob_cc_dcevt_obs  TYPE REF TO cl_gui_custom_container,
          ob_cc_det_flow   TYPE REF TO cl_gui_custom_container,
          ob_cc_vld_item   TYPE REF TO cl_gui_custom_container,
          ob_cc_grid       TYPE REF TO cl_gui_alv_grid,
          ob_cc_vld_head   TYPE REF TO cl_gui_custom_container,
          ob_cc_grid_head  TYPE REF TO cl_gui_alv_grid,
          ob_ht_object     TYPE REF TO cl_alv_event_toolbar_set,
          ob_cc_ht         TYPE REF TO cl_gui_custom_container,
          ob_cc_ht_grid    TYPE REF TO cl_gui_alv_grid,
          ob_cc_ped        TYPE REF TO cl_gui_custom_container,
          ob_cc_ped_grid   TYPE REF TO cl_gui_alv_grid,
          ob_cc_xml        TYPE REF TO cl_gui_custom_container,
          ob_cc_xml_grid   TYPE REF TO cl_gui_alv_grid,
          ob_cc_comp       TYPE REF TO cl_gui_custom_container,
          ob_cc_comp_grid  TYPE REF TO cl_gui_alv_grid.

*** ---------------------------------------------------------------- ***
*** Variáveis Globais
*** ---------------------------------------------------------------- ***
    DATA:  save_ok        TYPE sy-ucomm,
           ok_code        TYPE sy-ucomm,

           vg_url         TYPE cndp_url,
           vg_icon_id     TYPE cndp_url,
           vg_icon_url    TYPE cndp_url,
           vg_selid       TYPE rsdynsel-selid,
           vg_actnum      TYPE sy-tfill,
           vg_title       TYPE sy-title,
           v_index        TYPE sy-tabix,
           vg_status      TYPE string,
           vg_qtsel       TYPE sy-tabix,
           vg_chave       TYPE zhms_de_chave,
           vg_chave_sel   TYPE zhms_de_chave,
           vg_chave_main  TYPE zhms_de_chave,
           vg_natdc       TYPE zhms_de_natdc,
           vg_typed       TYPE zhms_de_typed,
           vg_loctp       TYPE zhms_de_loctp,
           vg_event       TYPE zhms_de_event,
           vg_versn       TYPE zhms_de_versn,
           vg_vld_shwhst  TYPE flag,
           vg_vld_shwdlt  TYPE flag   VALUE 'X',
           vg_vis_shwhead TYPE flag   VALUE 'X',
           vg_vis_shwitem TYPE flag   VALUE 'X',
           vg_edurl(2048) TYPE c,
* Rodolfo Caruzo - 04/04/2018 - Início
           vg_diretorio   TYPE sapb-sappfad,
           vg_dir_temp    TYPE sapb-sappfad,
* Rodolfo Caruzo - 04/04/2018 - Fim
           vg_screen_call TYPE c,
           vg_metric      TYPE cntl_metric_factors,
           vg_tdsrf       LIKE zhms_tb_itmatr-tdsrf VALUE 1,
           vg_atprp       LIKE zhms_tb_itmatr-atprp,
           vg_handle(3)   TYPE c,
           v_gate         TYPE zhms_de_gate,
           v_observ       TYPE string,
           vg_flowd       TYPE zhms_de_flowd,
           vg_funct       TYPE zhms_de_funct_esto,
           vg_codmp       TYPE zhms_de_codmp,
           vg_nfenum      TYPE char11,
           v_line         TYPE sy-tabix,
           vg_estorno     TYPE char1,
           vg_line        TYPE sy-tabix,
           vg_docnr       TYPE vbak-vbeln,
           lv_block_atrib TYPE char1,
           vg_unit_xml    TYPE c LENGTH 10,
           vg_unit_ped    TYPE c LENGTH 10,
           it_flwdoc      TYPE TABLE OF zhms_tb_flwdoc,
           vg_pedido      TYPE c LENGTH 10,
           vg_afnam       TYPE afnam,
           vg_ebelp       TYPE i,
           vg_seqnr       TYPE c,
*Homine - Incio da Inclusão - DD - Ajuste atribuição
           vg_atr_exc     type sy-ucomm.
*Homine - Fim da Inclusão - DD - Ajuste atribuição
*** ---------------------------------------------------------------- ***
*** Controle de Sub-Telas
*** ---------------------------------------------------------------- ***
    DATA: vg_0100        TYPE sy-dynnr  VALUE '0111',
          vg_0110        TYPE sy-dynnr  VALUE '0120',
          vg_0111_index  TYPE sy-dynnr  VALUE '0130',
          vg_0111_logo   TYPE sy-dynnr  VALUE '0120',
          vg_0112_index  TYPE sy-dynnr  VALUE '0130',
          vg_0112_docs   TYPE sy-dynnr  VALUE '0140',
          vg_0112_detail TYPE sy-dynnr  VALUE '0160',
          vg_0113_docs   TYPE sy-dynnr  VALUE '0140',
          vg_0113_detail TYPE sy-dynnr  VALUE '0160',
          vg_015o_det    TYPE sy-dynnr  VALUE '0151',
          vg_0200        TYPE sy-dynnr  VALUE '0210',
          vg_0400        TYPE sy-dynnr  VALUE '0401',
          vg_0405        TYPE sy-dynnr  VALUE '0405',
          vg_0406        TYPE sy-dynnr  VALUE '0406',
          vg_0151        TYPE sy-dynnr  VALUE '0160',
          vg_0158        TYPE sy-dynnr  VALUE '0158',
          vg_0159        TYPE sy-dynnr  VALUE '0159',
          vg_0161        TYPE sy-dynnr  VALUE '0161',
          vg_0500        TYPE sy-dynnr  VALUE '0501',
          vg_0503        TYPE sy-dynnr  VALUE '0503',
          vg_0600        TYPE sy-dynnr  VALUE '0602',
          vg_just_ok     TYPE char1.

    FIELD-SYMBOLS <or_value> TYPE any.

*** ---------------------------------------------------------------- ***
*** Tab-Strip's
*** ---------------------------------------------------------------- ***
    CONTROLS: tc_logdoc     TYPE TABLEVIEW USING SCREEN 0300.

*----------------------------------------------------------------------*
*   Declarações Globais da Classe
*----------------------------------------------------------------------*
*** Tabelas Internas
    DATA: t_evt_docs  TYPE cntl_simple_events,
          t_evt_det   TYPE cntl_simple_events.
*** Áreas de Trabalho
    DATA: wa_evt_docs TYPE cntl_simple_event,
          wa_evt_det  TYPE cntl_simple_event,
          ls_show_lay TYPE zhms_tb_show_lay .

*&SPWIZARD: FUNCTION CODES FOR TABSTRIP 'TS_DET_DOC'
    CONSTANTS: BEGIN OF c_ts_det_doc,
                 tab1 LIKE sy-ucomm VALUE 'TS_DET_DOC_FC1',
                 tab2 LIKE sy-ucomm VALUE 'TS_DET_DOC_FC2',
                 tab3 LIKE sy-ucomm VALUE 'TS_DET_DOC_FC3',
               END OF c_ts_det_doc.
*&SPWIZARD: DATA FOR TABSTRIP 'TS_DET_DOC'
    CONTROLS:  ts_det_doc TYPE TABSTRIP.
    DATA:      BEGIN OF g_ts_det_doc,
                 subscreen   LIKE sy-dynnr,
                 prog        LIKE sy-repid VALUE 'SAPLZHMS_FG_MONITOR',
                 pressed_tab LIKE sy-ucomm VALUE c_ts_det_doc-tab1,
               END OF g_ts_det_doc.

*&SPWIZARD: DECLARATION OF TABLECONTROL 'TC_ATR_ITMATR' ITSELF
    CONTROLS: tc_atr_itmatr TYPE TABLEVIEW USING SCREEN 0502.

*&SPWIZARD: LINES OF TABLECONTROL 'TC_ATR_ITMATR'
    DATA:     g_tc_atr_itmatr_lines  LIKE sy-loopc.

*&SPWIZARD: DECLARATION OF TABLECONTROL 'TC_PRT_DOCRCBTO' ITSELF
    CONTROLS: tc_prt_docrcbto TYPE TABLEVIEW USING SCREEN 0200.

*&SPWIZARD: DECLARATION OF TABLECONTROL 'TC_CNF_DOCCONF' ITSELF
    CONTROLS: tc_cnf_docconf TYPE TABLEVIEW USING SCREEN 0250.

*&SPWIZARD: DECLARATION OF TABLECONTROL 'TC_CNF_DATCONF' ITSELF
    CONTROLS: tc_cnf_datconf TYPE TABLEVIEW USING SCREEN 0251.

*&SPWIZARD: DECLARATION OF TABLECONTROL 'TC_FLWDOC' ITSELF
    CONTROLS: tc_flwdoc TYPE TABLEVIEW USING SCREEN 0170.

*&SPWIZARD: DECLARATION OF TABLECONTROL 'TC_001' ITSELF
    CONTROLS: tc_001 TYPE TABLEVIEW USING SCREEN 0407.

*&SPWIZARD: FUNCTION CODES FOR TABSTRIP 'TAB_01'
    CONSTANTS: BEGIN OF c_tab_01,
                 tab1 LIKE sy-ucomm VALUE 'TAB_01_FC1',
                 tab2 LIKE sy-ucomm VALUE 'TAB_01_FC2',
               END OF c_tab_01.
*&SPWIZARD: DATA FOR TABSTRIP 'TAB_01'
    CONTROLS:  tab_01 TYPE TABSTRIP.
    DATA:      BEGIN OF g_tab_01,
                 subscreen   LIKE sy-dynnr,
                 prog        LIKE sy-repid VALUE 'SAPLZHMS_FG_MONITOR',
                 pressed_tab LIKE sy-ucomm VALUE c_tab_01-tab1,
               END OF g_tab_01.

*&---------------------------------------------------------------------*
*&       Class LCL_HOTSPOT_CLICK
*&---------------------------------------------------------------------*
*        Text
*----------------------------------------------------------------------*
    CLASS lcl_hotspot_click DEFINITION.
      PUBLIC SECTION.
        METHODS:
        handle_hotspot_click
        FOR EVENT hotspot_click OF cl_gui_alv_grid IMPORTING e_row_id.
    ENDCLASS.               "LCL_HOTSPOT_CLICK

*&SPWIZARD: FUNCTION CODES FOR TABSTRIP 'TABSTRIPLOGS'
    CONSTANTS: BEGIN OF c_tabstriplogs,
                 tab1 LIKE sy-ucomm VALUE 'TABSTRIPLOGS_FC1',
                 tab2 LIKE sy-ucomm VALUE 'TABSTRIPLOGS_FC2',
               END OF c_tabstriplogs.
*&SPWIZARD: DATA FOR TABSTRIP 'TABSTRIPLOGS'
    CONTROLS:  tabstriplogs TYPE TABSTRIP.
    DATA:      BEGIN OF g_tabstriplogs,
                 subscreen   LIKE sy-dynnr,
                 prog        LIKE sy-repid VALUE 'SAPLZHMS_FG_MONITOR',
                 pressed_tab LIKE sy-ucomm VALUE c_tabstriplogs-tab1,
               END OF g_tabstriplogs.

*&SPWIZARD: DECLARATION OF TABLECONTROL 'TC_LOGSCONEC' ITSELF
    CONTROLS: tc_logsconec TYPE TABLEVIEW USING SCREEN 0603.

*&SPWIZARD: LINES OF TABLECONTROL 'TC_LOGSCONEC'
    DATA:     g_tc_logsconec_lines  LIKE sy-loopc.

*&SPWIZARD: DECLARATION OF TABLECONTROL 'TC_ERROSLOG' ITSELF
    CONTROLS: tc_erroslog TYPE TABLEVIEW USING SCREEN 0603.

*&SPWIZARD: LINES OF TABLECONTROL 'TC_ERROSLOG'
    DATA:     g_tc_erroslog_lines  LIKE sy-loopc.

*&SPWIZARD: DECLARATION OF TABLECONTROL 'TC_ERROSLOGS' ITSELF
    CONTROLS: tc_erroslogs TYPE TABLEVIEW USING SCREEN 0603.

*&SPWIZARD: DECLARATION OF TABLECONTROL 'TC_ERROSLOGC' ITSELF
    CONTROLS: tc_erroslogc TYPE TABLEVIEW USING SCREEN 0603.

*&SPWIZARD: LINES OF TABLECONTROL 'TC_ERROSLOGC'
    DATA:     g_tc_erroslogc_lines  LIKE sy-loopc.

*&SPWIZARD: DECLARATION OF TABLECONTROL 'TC_ERROSLOGCO' ITSELF
    CONTROLS: tc_erroslogco TYPE TABLEVIEW USING SCREEN 0603.

*&SPWIZARD: LINES OF TABLECONTROL 'TC_ERROSLOGCO'
    DATA:     g_tc_erroslogco_lines  LIKE sy-loopc.

*&SPWIZARD: DECLARATION OF TABLECONTROL 'TC_ERROSLOGCODE' ITSELF
    CONTROLS: tc_erroslogcode TYPE TABLEVIEW USING SCREEN 0604.

*&SPWIZARD: LINES OF TABLECONTROL 'TC_ERROSLOGCODE'
    DATA:     g_tc_erroslogcode_lines  LIKE sy-loopc.

*&SPWIZARD: DECLARATION OF TABLECONTROL 'TC_ERROSLOGDET' ITSELF
    CONTROLS: tc_erroslogdet TYPE TABLEVIEW USING SCREEN 0604.

*&SPWIZARD: LINES OF TABLECONTROL 'TC_ERROSLOGDET'
    DATA:     g_tc_erroslogdet_lines  LIKE sy-loopc.

*&SPWIZARD: DECLARATION OF TABLECONTROL 'TC_SHOW_PO' ITSELF
    CONTROLS: tc_show_po TYPE TABLEVIEW USING SCREEN 0503.

*&SPWIZARD: LINES OF TABLECONTROL 'TC_SHOW_PO'
    DATA:     g_tc_show_po_lines  LIKE sy-loopc.

*&SPWIZARD: DECLARATION OF TABLECONTROL 'TC_J1B1N_IMP' ITSELF
    CONTROLS: tc_j1b1n_imp TYPE TABLEVIEW USING SCREEN 0700.

*&SPWIZARD: FUNCTION CODES FOR TABSTRIP 'ABA_001'
    CONSTANTS: BEGIN OF c_aba_001,
                 tab1 LIKE sy-ucomm VALUE 'ABA_001_FC1',
                 tab2 LIKE sy-ucomm VALUE 'ABA_001_FC2',
                 tab3 LIKE sy-ucomm VALUE 'ABA_001_FC3',
               END OF c_aba_001.
*&SPWIZARD: DATA FOR TABSTRIP 'ABA_001'
    CONTROLS:  aba_001 TYPE TABSTRIP.
    DATA:      BEGIN OF g_aba_001,
                 subscreen   LIKE sy-dynnr,
                 prog        LIKE sy-repid VALUE 'SAPLZHMS_FG_MONITOR',
                 pressed_tab LIKE sy-ucomm VALUE c_aba_001-tab1,
               END OF g_aba_001.

DATA: BEGIN OF t_bdc1 OCCURS 0.
        INCLUDE STRUCTURE bdcdata.
DATA: END OF t_bdc1.

* ESTRTURA DE MENSAGENS DO SAP.
DATA: BEGIN OF t_mess OCCURS 0.
        INCLUDE STRUCTURE bdcmsgcoll.
DATA: END OF t_mess.


*VAriaveis Globais
DATA: v_mode_batch  TYPE c value 'N',
      ls_mess type bdcmsgcoll,
       v_lifnr_cont  type c.
