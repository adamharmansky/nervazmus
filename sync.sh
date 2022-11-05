#!/bin/sh

echo "Uploading files to the server..."
# rsync -rtP --filter "- .git" . saltovergold@saltovergold.gympos.sk:/public
lftp -e "mirror -eRv -x .git . /public/; quit;" sftp://saltovergold@saltovergold.gympos.sk
