CLASS zcl_download_action DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_download_action IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA:
      lt_properties TYPE cmis_t_client_property,
      ls_property   LIKE LINE OF lt_properties,
      ls_value      LIKE LINE OF ls_property-values,
      ls_content    TYPE cmis_s_content_raw,
      lv_print      TYPE string.

**********************************************************************
* Get the CMIS Client                                                                                      *
**********************************************************************
    DATA(lo_cmis_client) = z_cl_get_cmis_client=>get_client(  ).

    out->write( '*-----------------------------------------------------') .
    out->write( '* Executing create') .
    out->write( '*-----------------------------------------------------') .

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
    lv_print = ' New code class'.
    "ls_content-stream = cl_soap_xml_helper=>string_to_xstring( lv_print ).
    ls_content-stream = cl_abap_conv_codepage=>create_out(
                            codepage = `UTF-8`)->convert( source = lv_print ).

    "Call create_document
    CALL METHOD lo_cmis_client->create_document
      EXPORTING
        iv_repository_id = 'ZTEST_steampunk'
        it_properties    = lt_properties
        is_content       = ls_content
        iv_folder_id     = '6362f27000345f5a0142eaf5'
      IMPORTING
        es_object        = DATA(ls_cmis_object).

    "get the file-name
    DATA(lv_properties) = ls_cmis_object-properties-properties. "properties of the newly-created document
    READ TABLE lv_properties INTO DATA(ls_prop) WITH KEY id = cl_cmis_property_ids=>name.
    READ TABLE ls_prop-value INTO DATA(lv_name_prop) INDEX 1.
    DATA(lv_object_name) = lv_name_prop-string_value. "name of the file

    "get the file id
    READ TABLE lv_properties INTO ls_prop WITH KEY id = cl_cmis_property_ids=>object_id.
    READ TABLE ls_prop-value INTO DATA(lv_file_prop) INDEX 1.
    DATA(lv_object_id) = lv_file_prop-string_value. "name of the id

**********************************************************************
* Download the object                                                                                     *
**********************************************************************
    CALL METHOD lo_cmis_client->get_content_stream
      EXPORTING
        iv_repository_id = 'ZTEST_steampunk'
        iv_object_id     = lv_object_id
      IMPORTING
        es_content       = DATA(lv_content).

    out->write( '*-----------------------------------------------------') .
     out->write( '* Getting the content') .
     out->write( lv_content-filename ) .
     out->write( lv_content-mime_type ) .
     out->write( lv_content-length ) .
     out->write( lv_content-stream ) .
    out->write( '*-----------------------------------------------------') .


  ENDMETHOD.
ENDCLASS.
