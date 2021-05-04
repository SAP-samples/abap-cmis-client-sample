CLASS zcl_append_content_stream DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_append_content_stream IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA:
      lt_properties  TYPE cmis_t_client_property,
      ls_property    LIKE LINE OF lt_properties,
      ls_user        TYPE string,
      lo_cmis_client TYPE REF TO if_cmis_client,
      ls_value       LIKE LINE OF ls_property-values,
      ls_content     TYPE cmis_s_content_raw,
      lv_print       TYPE string,
      ls_cmis_object TYPE cmis_s_object,
      lv_object_id   TYPE cmis_id.
**********************************************************************
* Get the CMIS Client                                                                                      *
**********************************************************************
    lo_cmis_client = z_cl_get_cmis_client=>get_client(  ).

**********************************************************************
*Get the repository                                                                                         *
**********************************************************************
    CALL METHOD lo_cmis_client->get_repository_info
    EXPORTING
    iv_repository_id = 'Test_Repo' "pass the id of the created repository
      IMPORTING
        es_repository_info = DATA(ls_repository).
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
    ls_value-string_value = |Append_content{  cl_abap_context_info=>get_system_date( ) }{ cl_abap_context_info=>get_system_time( ) }.txt|.
    APPEND ls_value TO ls_property-values.
    APPEND ls_property TO lt_properties.

    "specify the content-stream details
    ls_content-filename = ls_value-string_value.
    ls_content-mime_type = 'text/plain'.
    lv_print = ' This is the first line'.
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
    DATA(lv_properties) = ls_cmis_object-properties-properties.
    READ TABLE lv_properties INTO DATA(ls_prop)  WITH KEY id = cl_cmis_property_ids=>name.
    READ TABLE ls_prop-value INTO DATA(lv_prop) INDEX 1.
    lv_print = |Document name : { lv_prop-string_value }|.
    out->write( lv_print ).
    READ TABLE lv_properties INTO ls_prop WITH KEY id = cl_cmis_property_ids=>version_label.
    READ TABLE ls_prop-value INTO lv_prop INDEX 1.
    lv_print = |Documennt version : { lv_prop-string_value }|.
    out->write( lv_print ).
    out->write( '-----------------------------------------------------') .

    "Get the id of the created document
    lv_properties = ls_cmis_object-properties-properties.
    READ TABLE lv_properties INTO ls_prop WITH KEY id = cl_cmis_property_ids=>object_id.
    READ TABLE ls_prop-value INTO lv_prop INDEX 1.
    lv_object_id = lv_prop-string_value.

**********************************************************************
* Checkout a document                                                                                     *
**********************************************************************
    CALL METHOD lo_cmis_client->check_out(
      EXPORTING
        iv_repository_id = ls_repository-id
        iv_object_id     = lv_object_id
      IMPORTING
        es_object        = ls_cmis_object "the checked-out document or the Private Working Copy
    ).
    "Get the id of the created document
    "for versioned repository, when a file is checked-out a PWC is created
    "edit operations are done on the PWC and the new file is checked-in
    lv_properties = ls_cmis_object-properties-properties. "properties of the newly-created document
    READ TABLE lv_properties INTO ls_prop WITH KEY id = cl_cmis_property_ids=>object_id.
    READ TABLE ls_prop-value INTO lv_prop INDEX 1.
    CLEAR: lv_object_id.
    lv_object_id = lv_prop-string_value. "id of the PWC

    "specify the content-stream details
    ls_content-mime_type = 'text/plain'.
    lv_print = '  This is the second line'.
    ls_content-stream = cl_abap_conv_codepage=>create_out(
                            codepage = `UTF-8`)->convert( source = lv_print ).
**********************************************************************
* Call append content-stream                                                                            *
**********************************************************************

    CALL METHOD lo_cmis_client->append_content_stream
      EXPORTING
        iv_repository_id = ls_repository-id
        iv_object_id     = lv_object_id
        is_content       = ls_content.

    "specify the content-stream details
    ls_content-mime_type = 'text/plain'.
    lv_print = ' This is the third line'.
    ls_content-stream = cl_abap_conv_codepage=>create_out(
                            codepage = `UTF-8`)->convert( source = lv_print ).
**********************************************************************
* Call append content-stream                                                                            *
**********************************************************************

    CALL METHOD lo_cmis_client->append_content_stream
      EXPORTING
        iv_repository_id = ls_repository-id
        iv_object_id     = lv_object_id
        is_content       = ls_content.

    "specify the content-stream details
    ls_content-mime_type = 'text/plain'.
    lv_print = ' This is the final line'.
    ls_content-stream = cl_abap_conv_codepage=>create_out(
                            codepage = `UTF-8`)->convert( source = lv_print ).
**********************************************************************
* Call append content-stream                                                                            *
**********************************************************************

    CALL METHOD lo_cmis_client->append_content_stream
      EXPORTING
        iv_repository_id = ls_repository-id
        iv_object_id     = lv_object_id
        is_content       = ls_content
        iv_last_chunk    = abap_true.
**********************************************************************
* Finaly, do a check-in                                                                                *
**********************************************************************
    CALL METHOD lo_cmis_client->check_in
      EXPORTING
        iv_object_id       = lv_object_id
        iv_repository_id   = ls_repository-id
        iv_major           = abap_false
        iv_checkin_comment = 'Completed append content-stream'.
  ENDMETHOD.
ENDCLASS.
