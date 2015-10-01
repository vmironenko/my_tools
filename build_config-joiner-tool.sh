cd ../modular-adserver
 ansible-playbook -i ./inventory/infrastructure ./playbooks/build.yml --tags=config-joiner-tool -s -e 'branch=modular-adserver publish=y' -v
# ansible-playbook -i ./inventory/infrastructure ./playbooks/publish.yml --tags=adserver -s -e 'version=5.0.0-SNAPSHOT branch=modular-adserver' -vv 
   
   