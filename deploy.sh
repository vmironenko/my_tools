cd ../adserving-devops
sudo -u jenkins ansible-playbook -i ./inventory/performance ./playbooks/deploy.yml --tags=adserver -u thumbtack -s -e 'version=5.0.0-SNAPSHOT branch=modular-adserver'  -l 10.1.43.60 -vvv
 