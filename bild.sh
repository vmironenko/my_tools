cd ../adserving-devops
 ansible-playbook -i ./inventory/infrastructure ./playbooks/build.yml --tags=adserver -s -e 'version=5.0.0-SNAPSHOT branch=modular-adserver' -v
# ansible-playbook -i ./inventory/infrastructure ./playbooks/publish.yml --tags=adserver -s -e 'version=5.0.0-SNAPSHOT branch=modular-adserver' -vv 
 