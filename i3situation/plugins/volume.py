import alsaaudio
from i3situation.plugins._plugin import Plugin

__all__ = 'VolumePlugin'


class VolumePlugin(Plugin):
    def __init__(self, config):
        self.options = {'device': 'master'}
        super().__init__(config)

    def main(self):
        mixer = alsaaudio.Mixer()
        if mixer.getmute()[0] == 0:
            finalOutput = "Vol:" + str(mixer.getvolume()[0])
        else:
            finalOutput = "Muted"
        return self.output(finalOutput, finalOutput)
