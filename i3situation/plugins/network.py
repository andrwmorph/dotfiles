import subprocess
import netifaces
from i3situation.plugins._plugin import Plugin

__all__ = 'NetworkPlugin'


class NetworkPlugin(Plugin):
    """
    A plugin that runs arbitrary shell commands and outputs them to the bar.
    USE WITH CAUTION.
    """

    def __init__(self, config):
        self.options = {'interface': 'net0', 'interval': 30}
        super().__init__(config)

    def main(self):
        #shellOutput = subprocess.check_output(self.options['command'].split(' '), stderr=subprocess.STDOUT).decode('utf-8')
        ifaceName = self.options['interface']
        iface = netifaces.ifaddresses(ifaceName).get(netifaces.AF_INET)
        #finalOutput = iface
        if iface != None:
            finalOutput = ifaceName + ":" + iface[0]['addr']
        else:
            finalOutput = ifaceName + ": No Connection"
        #finalOutput += " " + i + ":" + j['addr']
        return self.output(finalOutput, finalOutput)
