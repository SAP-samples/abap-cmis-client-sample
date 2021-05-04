CLASS zcl_delete_action DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_delete_action IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA:
      lo_cmis_client TYPE REF TO if_cmis_client,
      ls_children    TYPE cmis_s_object_in_folder_list,
      lv_print       TYPE string.

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
* Get all the children of the Root Folder                                                            *
**********************************************************************
    CALL METHOD lo_cmis_client->get_children
      EXPORTING
        iv_folder_id     = ls_repository-root_folder_id
        iv_repository_id = ls_repository-id
      IMPORTING
        es_children      = ls_children.

    out->write( '*-----------------------------------------------------') .
    out->write( '* Executing delete') .
    out->write( '*-----------------------------------------------------') .
    lv_print = | Number of objects to be deleted: { lines( ls_children-objects_in_folder )  } |.
    out->write( lv_print ).
    out->write( '-----------------------------------------------------') .
    LOOP AT ls_children-objects_in_folder INTO DATA(lv_object).
      DATA(lv_properties) = lv_object-object-properties-properties.
      READ TABLE lv_properties INTO DATA(ls_objectid_prop)  WITH KEY id = cl_cmis_property_ids=>object_id.
      READ TABLE ls_objectid_prop-value INTO DATA(ls_objectid) INDEX 1.
      READ TABLE lv_properties INTO DATA(ls_object_type_id_prop)  WITH KEY id = cl_cmis_property_ids=>object_type_id.
      READ TABLE ls_object_type_id_prop-value INTO DATA(ls_object_type_id) INDEX 1.
      IF ls_object_type_id-string_value EQ cl_cmis_constants=>base_type_id-cmis_folder.
**********************************************************************
*  Delete a folder                                                                                             *
**********************************************************************
        CALL METHOD lo_cmis_client->delete_tree
          EXPORTING
            iv_all_versions        = abap_true  "for versioned repository
            iv_continue_on_failure = abap_true
            iv_object_id           = ls_objectid-string_value
            iv_repository_id       = ls_repository-id.
      ELSE .
**********************************************************************
*  Delete a document                                                                                        *
**********************************************************************
        "check if the document is a pwc. Then do a cancel check-out
        READ TABLE lv_properties INTO DATA(ls_pwc)  WITH KEY id = cl_cmis_property_ids=>is_private_working_copy.
        READ TABLE ls_pwc-value INTO DATA(ls_pwc_value) INDEX 1.
        IF ls_pwc_value-boolean_value EQ abap_true.
          CALL METHOD lo_cmis_client->cancel_check_out
            EXPORTING
              iv_object_id     = ls_objectid-string_value
              iv_repository_id = ls_repository-id.
        ELSE.
          "delete the file
          CALL METHOD lo_cmis_client->delete
            EXPORTING
              iv_all_versions  = abap_true "for versioned repository
              iv_object_id     = ls_objectid-string_value
              iv_repository_id = ls_repository-id.
        ENDIF.
      ENDIF.

      lv_print = |Deleted { ls_object_type_id-string_value } with id { ls_objectid-string_value } |.
      out->write( lv_print ) .
      out->write( '-----------------------------------------------------') .
    ENDLOOP.

    lv_print = |Deleted contents of the folder { ls_repository-id }. |.
    out->write( lv_print ) .
    out->write( '-----------------------------------------------------') .

**********************************************************************
* Delete the custom-type                                                                                 *
**********************************************************************
    TRY.
        lo_cmis_client->delete_type(
        EXPORTING
        iv_repository_id = ls_repository-id
        iv_type_id = 'custom:Type' "custom type created
        ).
        out->write( 'custom:Type is deleted.' ) .
      CATCH cx_cmis_object_not_found.
        out->write( 'custom:Type does not exist.') .
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
