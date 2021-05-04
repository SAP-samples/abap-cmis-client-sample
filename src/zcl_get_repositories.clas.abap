CLASS zcl_get_repositories DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_get_repositories IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA:
      ls_user        TYPE string,
      lo_cmis_client TYPE REF TO if_cmis_client.
    out->write('Get Repositories').
    ls_user = sy-uname.

**********************************************************************
* Get the CMIS Client                                                                                      *
**********************************************************************
    lo_cmis_client = z_cl_get_cmis_client=>get_client(  ).

**********************************************************************
*Get all the repositories                                                                                   *
**********************************************************************
    CALL METHOD lo_cmis_client->get_repositories
      IMPORTING
        et_repository_infos = DATA(lt_repository_infos).


    out->write( '----------------------------------------------------------' ).
    LOOP AT lt_repository_infos INTO DATA(ls_repository_info).
      DATA(lv_print) = | Repository Id: { ls_repository_info-id } |.
      out->write( lv_print ).
      lv_print = | Product Name: { ls_repository_info-product_name }|.
      out->write( lv_print ).
      lv_print = | Repository Name: { ls_repository_info-name }, Root Folder:  { ls_repository_info-root_folder_id }|.
      out->write( lv_print ).
      out->write( '----------------------------------------------------------' ).
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
