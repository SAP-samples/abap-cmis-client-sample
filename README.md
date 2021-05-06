# Title
These are sample classes that helps you to use SAP Document Management, Integration option, in ABAP BTP.
## Description
Document Management Service, Integration Option lets you build document management capabilities for your business applications using the integration component or the easy-to-use, reusable UI component.
The following examples can be used for ABAP BTP.
## Requirements
Before using the classes, please do the following:
1. Create a service-instance of SAP Document Management, Integration option. 
Link: https://help.sap.com/viewer/f6e70dd4bffa4b65965b43feed4c9429/Cloud/en-US/bc0f1ec7d5374b968e0b0de6db470c94.html
2. Onboard a repository.
Link: https://api.sap.com/api/AdminAPI/resource
3. Install CMIS Workbench, and connect to your repository.
4. Connect to the ABAP BTP instance, and create a Communication Arrangement for SAP_COM_0668.

#### Using CMIS workbench to work with SDI Server
 - Download CMIS workbench

Download the latest version of CMIS workbench from Apache from here: https://chemistry.apache.org/java/download.html, or download the version with login tabs for CP Document Service and SAP Document Center: refer to https://github.com/SAP/cloud-cmis-workbench

- Create the service-key for your SDM service instance, with SERVICE_INSTANCE being the name of your instance and SERVICE-KEY is any string
``` code
cf create-service-key SERVICE-INSTANCE SERVICE-KEY
```

- Get the `uaa.url`, `uaa.clientid`, `uaa.clientsecret` and `endpoints.ecmservice` from your service key
``` code
cf service-key SERVICE-INSTANCE SERVICE-KEY
```

- Fetch JWT token from postman
```http
 POST : <uaa.url>/oauth/token?grant_type=client_credentials
 Type : Basic auth
 Username : <uaa.clientid>
 Password : <uaa.clientsecret>
```

- Open CMIS workbench and connect to repository
```http
URL : <endpoints.ecmservice>/browser
Binding: Browser
Authentication : OAuth 2.0 ( Bearer Token )
Username : <Bearer token from previous step>
```

- Click on load repository and start creating folders and documents

## Download and Installation
1. Create a Communication Arrangement for SAP_COM_0668 with the Document Management Service, Integration Option service-key in the ABAP BTP instance.
2. Clone the repository or use the abapGit client to import the sources into your SAP system.
3. Change the **Repository Id** to the one created by you.

## Sample Code Description:
| Class name  | Description |
| ------------- | ------------- |
| z_cl_get_cmis_client | Gets the if_cmis_client_object. |
| zcl_get_repositories | Gets all the repositories of the service-instance. |
| zcl_create_actions | Creates a folder and a document. |
| zcl_delete_action | Deletes folder, document, does cancel check-out for PWC and deletes a custom type. |
| zcl_get_type | Returns a simple type. |
| zcl_query_action | Runs a query and prints the results. |
| zcl_type_action | Shows how to fetch a type from the repository and to create a custom type. |
| zcl_versioning_demo | Shows how to create versions. It will only work in a versioned repository. |
| zcl_append_content_stream | Shows how to append a content-stream. For non-versioned repository, call append content-stream directly after create document. |

#### Note:
1. When a Communication Arrangement is created for SAP_COM_0668, a Communication System 'ZSAP_COM_0668' is created internally.
2. Actions like creating a major version, append content-stream,etc, will be supported only by certain repositories. Please consult with your repository vendor.
3. The classes CL_CMIS_CLIENT_FACTORY and IF_CMIS_CLIENT talks directly to the SDI service instance. The api calls are metered by the service-instance.
4. By design, only one instance of SDI is connected to one ABAP-BTP instance. 
5. You can update the Communication Scenario to connect it with a new instance.

## Known Issues

## How to obtain support

[Create an issue](https://github.com/SAP-samples/<repository-name>/issues) in this repository if you find a bug or have questions about the content.
You can also create an incident with the component BC-SRV-MCM-SER or BC-CP-CF-SDM-INT.
 
For additional support, [ask a question in SAP Community](https://answers.sap.com/questions/ask.html).

## Contributing
This project can be updated by SAP employees.

## License
Copyright (c) 2021 SAP SE or an SAP affiliate company. All rights reserved. This project is licensed under the Apache Software License, version 2.0 except as noted otherwise in the [LICENSE](LICENSES/Apache-2.0.txt) file.
