# -*- encoding: utf-8 -*-

import subprocess

cmd = ["docker", "ps", "--format", "table {{.ID}} {{.Names}}"]
containers = subprocess.check_output(cmd)
item_filters = ['Containers', 'Images', 'Dirs']#, "Server Version", "Name"]


for container in containers.splitlines()[1:]:
    container_id, name = container.strip().split()
    print "name", name,
    cmd_exec_base = ['docker', 'exec', '-it', name]
    # cmd = ['docker', 'exec', '-it', name, 'docker', 'pull', 'vauxoo/odoo-80-image-shippable-auto']
    # cmd = ["docker", "exec", "-it", name, "ps", "aux"]
    # out = subprocess.check_output(cmd)
    # print "out", out
#     if 'find' in out or "python odoo." in out:
#         print "*****************find found...."
    cmd = ['docker', 'info']
    container_info = subprocess.check_output(cmd_exec_base + cmd)
    for item_info in container_info.splitlines():
        item_info = item_info.strip()
        if not any([item_info.startswith(item_filter) for item_filter in item_filters]):
            continue
        
        item_info_key, item_info_value = item_info.split(':')
        item_info_key = item_info_key.strip()
        item_info_value = item_info_value.strip()
	print item_info_key, item_info_value,
    cmd = ['docker', 'version', '-f', '{{.Server.Version}}']
    container_version = subprocess.check_output(cmd_exec_base + cmd)
    print 'version:', container_version.strip(' \n'),
    print ""
