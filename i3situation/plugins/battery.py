import sys
import os
from i3situation.plugins._plugin import Plugin

__all__ = 'DateTimePlugin'
battery_file='/sys/class/power_supply/BAT0/capacity'

class DateTimePlugin(Plugin):

    def __init__(self, config):
        self.options = {'interval': 30}
        super().__init__(config)

    def main(self):
        batt=open(battery_file, 'r')
        return self.output(str(batt.readline())[:-1]+'%', '1')
        batt.close()
