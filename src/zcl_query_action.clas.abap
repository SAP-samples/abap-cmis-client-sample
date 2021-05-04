CLASS zcl_query_action DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_query_action IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA:
      ls_user         TYPE string,
      lo_cmis_client  TYPE REF TO if_cmis_client,
      ls_query_result TYPE cmis_s_object_list,
      lv_print        TYPE string.

**********************************************************************
* Get the logged-in user                                                                                   *
**********************************************************************
    TRY.
        CALL METHOD cl_abap_context_info=>get_user_formatted_name
          RECEIVING
            rv_formatted_name = ls_user.
      CATCH cx_abap_context_info_error.
    ENDTRY.

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

    "Form the query
    DATA(lv_query) = | SELECT * FROM cmis:document where cmis:createdBy = '{ ls_user }'|.

**********************************************************************
* Execute the query                                                                                         *
**********************************************************************

    CALL METHOD lo_cmis_client->query
      EXPORTING
        iv_repository_id = ls_repository-id
        iv_statement     = lv_query
      IMPORTING
        es_query_result  = ls_query_result.

    out->write( '*-----------------------------------------------------') .
    lv_print = |* Result of the query : { lv_query }|.
    out->write( lv_print ).
    out->write( '*-----------------------------------------------------') .

    lv_print = | Number of hits: { lines( ls_query_result-objects )  } |.
    out->write( lv_print ).
    out->write( '-----------------------------------------------------') .

    LOOP AT ls_query_result-objects INTO DATA(lv_object).

      DATA(lv_properties) = lv_object-properties-properties.
      READ TABLE lv_properties INTO DATA(ls_objectid_prop)  WITH KEY id = cl_cmis_property_ids=>object_id.
      READ TABLE ls_objectid_prop-value INTO DATA(lv_object_id) INDEX 1.
      READ TABLE lv_properties INTO DATA(ls_objectname_prop)  WITH KEY id = cl_cmis_property_ids=>name.
      READ TABLE ls_objectname_prop-value INTO DATA(lv_object_name) INDEX 1.

      lv_print = | Object Name: { lv_object_name-string_value }, Object Id: { lv_object_id-string_value } |.
      out->write( lv_print ).
      out->write( '-----------------------------------------------------') .

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
