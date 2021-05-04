CLASS zcl_create_actions DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_create_actions IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA:
      lt_properties  TYPE cmis_t_client_property,
      ls_property    LIKE LINE OF lt_properties,
      ls_user        TYPE string,
      lo_cmis_client TYPE REF TO if_cmis_client,
      ls_value       LIKE LINE OF ls_property-values,
      ls_content     TYPE cmis_s_content_raw,
      lv_print       TYPE string.

**********************************************************************
* Get the CMIS Client                                                                                      *
**********************************************************************
    lo_cmis_client = z_cl_get_cmis_client=>get_client(  ).

    out->write( '*-----------------------------------------------------') .
    out->write( '* Executing create') .
    out->write( '*-----------------------------------------------------') .

**********************************************************************
*Get the repository                                                                                         *
**********************************************************************
    CALL METHOD lo_cmis_client->get_repository_info
    EXPORTING
    iv_repository_id = 'Test_Repo' "pass the id of the created repository
      IMPORTING
        es_repository_info = DATA(ls_repository).

**********************************************************************
*Create a folder                                                                                              *
**********************************************************************
    ls_property-id        = cl_cmis_property_ids=>object_type_id.
    ls_value-string_value = cl_cmis_constants=>base_type_id-cmis_folder. "specify the type as cmis:folder
    APPEND ls_value TO ls_property-values.
    APPEND ls_property TO lt_properties.

    CLEAR: ls_property,  ls_value.

    ls_property-id        = cl_cmis_property_ids=>name. "specify the name of the file
    ls_value-string_value = |Test{  cl_abap_context_info=>get_system_date( ) }{ cl_abap_context_info=>get_system_time( ) }|.
    APPEND ls_value TO ls_property-values.
    APPEND ls_property TO lt_properties.

    "call create_folder
    CALL METHOD lo_cmis_client->create_folder
      EXPORTING
        iv_repository_id = ls_repository-id
        it_properties    = lt_properties
        iv_folder_id     = ls_repository-root_folder_id
      IMPORTING
        es_object        = DATA(ls_cmis_object).

    out->write('Folder created successfully.').
    out->write( '-----------------------------------------------------') .

**********************************************************************
* Create a document                                                                                         *
**********************************************************************

    CLEAR: ls_property,  ls_value.
    ls_property-id        = cl_cmis_property_ids=>object_type_id.
    ls_value-string_value = cl_cmis_constants=>base_type_id-cmis_document. "specify the type as cmis:document
    APPEND ls_value TO ls_property-values.
    APPEND ls_property TO lt_properties.

    CLEAR: ls_property,  ls_value.

    ls_property-id        = cl_cmis_property_ids=>name. "specify the name
    ls_value-string_value = |Doc{  cl_abap_context_info=>get_system_date( ) }{ cl_abap_context_info=>get_system_time( ) }.txt|.
    APPEND ls_value TO ls_property-values.
    APPEND ls_property TO lt_properties.

    "specify the content-stream details
    ls_content-filename = 'content'.
    ls_content-mime_type = 'text/plain'.
    lv_print = ' This is a file'.
    ls_content-stream = cl_abap_conv_codepage=>create_out(
                            codepage = `UTF-8`)->convert( source = lv_print ).

    "Call create_document
    CALL METHOD lo_cmis_client->create_document(
      EXPORTING
        iv_repository_id = ls_repository-id
        it_properties    = lt_properties
        is_content       = ls_content
        iv_folder_id     = ls_repository-root_folder_id
      IMPORTING
        es_object        = ls_cmis_object ).

    out->write('Document created successfully.').
    out->write( '-----------------------------------------------------') .

  ENDMETHOD.
ENDCLASS.
