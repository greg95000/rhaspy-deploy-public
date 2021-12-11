# rhaspy-deploy-public
pi-hole with nginx reverse proxy

1) Setup your .env

2) Put the install script as executable with

`chmod +x install.sh`

3) Then execute install.sh with those parameters:

`--create-directories Create all the directories required for ssl nginx and pi-hole`\
`--generate-kpi Generate autosigned certificate + key for nginx`\
`--filter-youtube-ad Create the youtube ads automation to blacklist ads in pi-hole`

If you don't want to use autosigned certificate just use --create-directories which will create all need directories.\
After that you just have to put your certificates inside those directories and set the correct names in the .env

You can reexecute the install.sh script.