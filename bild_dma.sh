cd ../modular-adserver
# ansible-playbook -i ./inventory/infrastructure ./playbooks/build.yml --tags=adserver_dma -s -e 'version=1 iteration=2 dir=/opt/placeiq/lib' -v
 ansible-playbook -i ./inventory/infrastructure ./playbooks/publish.yml --tags=adserver_dma -s -e 'version=1 iteration=2' -vv 
 