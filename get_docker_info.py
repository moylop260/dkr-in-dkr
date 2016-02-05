# -*- encoding: utf-8 -*-

import subprocess

cmd = ["docker", "ps", "--format", "table {{.ID}} {{.Names}}"]
containers = subprocess.check_output(cmd)
item_filters = ['Containers', 'Images', 'Dirs']


for container in containers.splitlines()[1:]:
    container_id, name = container.strip().split()
    cmd = ['docker', 'exec', '-it', name, 'docker', 'info']
    container_info = subprocess.check_output(cmd)
    print "name", name,
    for item_info in container_info.splitlines():
        item_info = item_info.strip()
        if not any([item_info.startswith(item_filter) for item_filter in item_filters]):
            continue
        
        item_info_key, item_info_value = item_info.split(':')
        item_info_key = item_info_key.strip()
        item_info_value = item_info_value.strip()
        # if item_info_key not in ['Containers', 'Images', 'Dirs']:
        #    continue
	print item_info_key, item_info_value,
    print
# [item for item in container_info.splitlines() if item.strip()[:item.strip().find(':')] in ['Containers', 'Images', 'Dirs']]
# import pdb;pdb.set_trace()
# pass
