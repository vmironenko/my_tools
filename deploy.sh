cd ../modular-adserver
sudo -u jenkins ansible-playbook -i ./inventory/performance ./playbooks/deploy.yml --tags=adserver -u thumbtack -s -e 'v=v'  -l 10.1.43.60 -v
 