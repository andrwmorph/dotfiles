import subprocess
import netifaces
from i3situation.plugins._plugin import Plugin

__all__ = 'NetworkPlugin'


class NetworkPlugin(Plugin):

    def __init__(self, config):
        self.options = {'interface': 'net0', 'interval': 30}
        super().__init__(config)

    def main(self):
        ifaceName = self.options['interface']
        iface = netifaces.ifaddresses(ifaceName).get(netifaces.AF_INET)
        if iface != None:
            finalOutput = ifaceName + ":" + iface[0]['addr']
        else:
            finalOutput = ifaceName + ": No Connection"
        return self.output(finalOutput, finalOutput)
