CLASS zcl_get_type DEFINITION
  PUBLIC
  ABSTRACT
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS get_custom_type
      RETURNING
        VALUE(rs_custom_document_type) TYPE cmis_s_type_definition .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_get_type IMPLEMENTATION.

  METHOD get_custom_type.
    rs_custom_document_type-id = 'custom:Type'.
    rs_custom_document_type-local_name = 'custom:Type'.
    rs_custom_document_type-local_namespace = 'com.custom.namespace'.
    rs_custom_document_type-display_name = 'Custom Document'.
    rs_custom_document_type-query_name = 'custom:Type'.
    rs_custom_document_type-description = 'Custom document type'.
    rs_custom_document_type-parent_id = cl_cmis_constants=>base_type_id-cmis_document.
    rs_custom_document_type-base_id = cl_cmis_constants=>base_type_id-cmis_document.
    rs_custom_document_type-creatable = abap_true.
    rs_custom_document_type-fileable = abap_true.
    rs_custom_document_type-queryable = abap_true.
    rs_custom_document_type-doc_content_stream_allowed = cl_cmis_constants=>content_stream_allowed-allowed.
    rs_custom_document_type-full_text_indexed = abap_false.
    rs_custom_document_type-included_in_supertype_query = abap_true.
    rs_custom_document_type-controllable_policy = abap_false.
    rs_custom_document_type-controllable_acl = abap_true.
    rs_custom_document_type-type_mutability-create = abap_true.
    rs_custom_document_type-type_mutability-delete = abap_true.
    rs_custom_document_type-type_mutability-update = abap_true.
    rs_custom_document_type-fileable = abap_true.

    FIELD-SYMBOLS <ls_prop_def> TYPE cmis_s_property_definition.
    LOOP AT rs_custom_document_type-property_definitions ASSIGNING <ls_prop_def>.
      <ls_prop_def>-inherited = abap_true.
    ENDLOOP.

    DATA: lv_prop_def LIKE LINE OF rs_custom_document_type-property_definitions.

    lv_prop_def-id = 'customType:id'.
    lv_prop_def-local_name = 'customType:id'.
    lv_prop_def-local_namespace = 'com.custom.namespace'.
    lv_prop_def-display_name = 'customType:id'.
    lv_prop_def-query_name = 'customType:id'.
    lv_prop_def-description = 'customType:id'.
    lv_prop_def-property_type = cl_cmis_constants=>property_type-string.
    lv_prop_def-cardinality = cl_cmis_constants=>cardinality-single.
    lv_prop_def-updatability = cl_cmis_constants=>updatability-read_write.
    lv_prop_def-inherited = abap_false.
    lv_prop_def-required = abap_false.
    lv_prop_def-queryable = abap_false.
    lv_prop_def-orderable = abap_false.
    lv_prop_def-openchoice = abap_true.
    lv_prop_def-string_max_length = 4500.

    APPEND lv_prop_def TO rs_custom_document_type-property_definitions.
    CLEAR lv_prop_def.

    lv_prop_def-id = 'customType:name'.
    lv_prop_def-local_name = 'customType:name'.
    lv_prop_def-local_namespace = 'com.custom.namespace'.
    lv_prop_def-display_name = 'customType:name'.
    lv_prop_def-query_name = 'customType:name'.
    lv_prop_def-description = 'customType:name'.
    lv_prop_def-property_type = cl_cmis_constants=>property_type-string.
    lv_prop_def-cardinality = cl_cmis_constants=>cardinality-single.
    lv_prop_def-updatability = cl_cmis_constants=>updatability-read_write.
    lv_prop_def-inherited = abap_false.
    lv_prop_def-required = abap_false.
    lv_prop_def-queryable = abap_false.
    lv_prop_def-orderable = abap_false.
    lv_prop_def-openchoice = abap_true.
    lv_prop_def-string_max_length = 4500.

    APPEND lv_prop_def TO rs_custom_document_type-property_definitions.

  ENDMETHOD.
ENDCLASS.
