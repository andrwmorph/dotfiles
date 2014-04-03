import alsaaudio
from i3situation.plugins._plugin import Plugin

__all__ = 'VolumePlugin'


class VolumePlugin(Plugin):
    """
    A plugin that runs arbitrary shell commands and outputs them to the bar.
    USE WITH CAUTION.
    """

    def __init__(self, config):
        self.options = {'device': 'master'}
        super().__init__(config)

    def main(self):
        #shellOutput = subprocess.check_output(self.options['command'].split(' '), stderr=subprocess.STDOUT).decode('utf-8')
        #ifaceName = self.options['interface']
        #iface = netifaces.ifaddresses(ifaceName).get(netifaces.AF_INET)
        #finalOutput = iface
        #if iface != None:
        #    finalOutput = ifaceName + ":" + iface[0]['addr']
        #else:
        #    finalOutput = ifaceName + ": No Connection"
        #finalOutput += " " + i + ":" + j['addr']
        mixer = alsaaudio.Mixer()
        if mixer.getmute()[0] == 0:
            finalOutput = "Vol:" + str(mixer.getvolume()[0])
        else:
            finalOutput = "Muted"
        return self.output(finalOutput, finalOutput)
