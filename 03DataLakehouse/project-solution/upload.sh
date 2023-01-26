#! usr/bin/bash

# Parameters
databricks_workspace_url="<databricks-workspace-url>"
personal_access_token="<personal-access-token>"
local_file_path="<local_file_path>"              # ex: /Users/foo/Desktop/file_to_upload.png
dbfs_file_path="<dbfs_file_path>"                # ex: /tmp/file_to_upload.png
overwrite_file="<true|false>"


curl --location --request POST https://${databricks_workspace_url}/api/2.0/dbfs/put \
     --header "Authorization: Bearer ${personal_access_token}" \
     --form contents=@${local_file_path} \
     --form path=${dbfs_file_path} \
     --form overwrite=${overwrite_file}