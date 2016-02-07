# -*- encoding: utf-8 -*-

import csv
import subprocess


cmd = ["docker", "ps", "--format", "table {{.ID}} {{.Names}}"]
containers = subprocess.check_output(cmd)
item_filters = ['Containers', 'Images', 'Dirs']#, "Server Version", "Name"]
inspect_filters = ['Source', 'Destination', 'HostPort']
datas = []

for container in containers.splitlines()[1:]:
    container_id, name = container.strip().split()
    data_dict = {}
    data_dict['name'] = name
    print "Updating main image in ", name,
    cmd = ['docker', 'exec', '-it', name, 'docker', 'pull', 'vauxoo/odoo-80-image-shippable-auto']
    out = subprocess.check_output(cmd)
    continue
    cmd_exec_base = ['docker', 'exec', '-it', name]
    cmd = ['docker', 'info']
    container_info = subprocess.check_output(cmd_exec_base + cmd)
    for item_info in container_info.splitlines():
        item_info = item_info.strip()
        if not any([item_info.startswith(item_filter) for item_filter in item_filters]):
            continue
        
        item_info_key, item_info_value = item_info.split(':')
        item_info_key = item_info_key.strip()
        item_info_value = item_info_value.strip()
	data_dict[item_info_key] = item_info_value

    # get docker version info
    cmd = ['docker', 'version', '-f', '{{.Server.Version}}']
    container_version = subprocess.check_output(cmd_exec_base + cmd)
    data_dict['version'] = container_version.strip(' \r\n')
    # get docker port and volumes
    cmd = ['docker', 'inspect', name]
    container_inspect = subprocess.check_output(cmd)
    for item_inspect in container_inspect.splitlines():
        item_inspect = item_inspect.strip(' ,\r\n').replace('"', '')
	for inspect_filter in inspect_filters:
	    if item_inspect.startswith(inspect_filter):
		data_dict[inspect_filter] = item_inspect.split(':')[1].strip()
    datas.append(data_dict)

if datas:
    with open('data.csv', 'wb') as fcsv:
        fcsv_dict = csv.DictWriter(fcsv, datas[0])
        fcsv_dict.writeheader()
        fcsv_dict.writerows(datas)
    print datas
