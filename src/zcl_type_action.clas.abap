CLASS zcl_type_action DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_type_action IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA:
            lo_cmis_client TYPE REF TO if_cmis_client.
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
    out->write( '*-----------------------------------------------------') .
    out->write( '* Type action') .
    out->write( '*-----------------------------------------------------') .

**********************************************************************
* Get the "cmis:document" type-definition from repository                                *
**********************************************************************
    lo_cmis_client->get_type_definition(
    EXPORTING
            iv_repository_id = ls_repository-id
            iv_type_id = cl_cmis_constants=>base_type_id-cmis_document
            IMPORTING
            es_type = DATA(ls_document_base_type)
            ) .

**********************************************************************
* Create a custom-type                                                                                    *
**********************************************************************

    DATA(ls_custom_document_type) = zcl_get_type=>get_custom_type( ).

**********************************************************************
* Check if the type-definition already exists                                                      *
**********************************************************************
    TRY.
        lo_cmis_client->get_type_definition(
        EXPORTING
        iv_repository_id = ls_repository-id
        iv_type_id = 'custom:Type' "id of the custom-type created
        ).
      CATCH cx_cmis_object_not_found. "Type does not exist, so create the type

        out->write( '*-----------------------------------------------------') .
        out->write( '* Create Type') .
        out->write( '*-----------------------------------------------------') .

**********************************************************************
* If it does not exist, create the type                                                              *
**********************************************************************

        lo_cmis_client->create_type(
        EXPORTING
        iv_repository_id = ls_repository-id
        is_type = ls_custom_document_type
        IMPORTING
        es_type = DATA(ls_created_type)
         ).



    ENDTRY.
  ENDMETHOD.
ENDCLASS.
