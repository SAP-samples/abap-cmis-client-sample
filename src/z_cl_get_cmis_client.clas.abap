CLASS z_cl_get_cmis_client DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .
  PUBLIC SECTION.
    CLASS-METHODS get_client
      RETURNING
        VALUE(ro_cmis_client) TYPE REF TO if_cmis_client
      RAISING
        cx_cmis_permission_denied
        cx_cmis_runtime
        cx_cmis_invalid_argument
        cx_cmis_not_supported
        cx_cmis_object_not_found
        cx_cmis_unauthorized
        cx_cmis_oauth .
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA mo_cmis_client TYPE REF TO if_cmis_client.
ENDCLASS.



CLASS Z_CL_GET_CMIS_CLIENT IMPLEMENTATION.


  METHOD get_client.
    DATA:
          ls_user TYPE string.

***********************************************************************
** Get the CMIS Client
***********************************************************************
    IF mo_cmis_client IS NOT BOUND.
      CALL METHOD cl_cmis_client_factory2=>get_instance
        RECEIVING
          ro_client = mo_cmis_client.    " CMIS Client API
    ENDIF.


*****Below method is deprecated and a Succesor API logic is as mentioned
*****above. The user ID is fetched inside the Get_Instance method
***********************************************************************
** Get the logged-in user                                                                                   *
***********************************************************************
*
*    TRY.
*        CALL METHOD cl_abap_context_info=>get_user_formatted_name
*          RECEIVING
*            rv_formatted_name = ls_user.
*      CATCH cx_abap_context_info_error.
*    ENDTRY.
***********************************************************************
** Get the CMIS Client                                                                                      *
***********************************************************************
*
*    IF mo_cmis_client IS NOT BOUND.
*
*      CALL METHOD cl_cmis_client_factory=>get_instance
*        EXPORTING
*          iv_user_header = ls_user
*        RECEIVING
*          ro_client      = mo_cmis_client.
*    ENDIF.

    "Return the cmis-client
    ro_cmis_client = mo_cmis_client.

  ENDMETHOD.
ENDCLASS.
