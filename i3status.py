import os
from i3pystatus import Status

status = Status()

status.register('clock',
                format='%d/%m/%Y %H:%M',)

status.register('load',
                format='{avg1}')

status.register('disk',
                path='/',
                format='{percentage_avail}%')

hostname = os.uname()[1]
if hostname == 'lineufelipe.ws':
    status.register('network',
                    interface='enp3s0',
                    format_up='{interface} {v4cidr}')

status.run()
