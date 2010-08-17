from ranger.defaults.apps import CustomApplications as DefaultApps
from ranger.api.apps import *

class CustomApplications(DefaultApps):
    def app_evince(self, c):
        c.flags += 'd'
        return tup('evince', *c)

    def app_comix(self, c):
        c.flags += 'd'
        return tup('comix', *c)

    def app_mplayer(self, c):
        if c.mode is 2:
            args = "mplayer -channels 2".split()
            args.extend(c)
            return tup(*args)
        elif c.mode is 3:
            args = "playfrom".split()
            args.extend(c)
            return tup(*args)
        elif c.mode is 4:
            args = "playfrom -channels 2".split()
            args.extend(c)
            return tup(*args)
        else:
            return DefaultApps.app_mplayer(self, c)

    def app_default(self, c):
        f = c.file

        if f.extension in ('pdf'):
            return self.app_evince(c)

        if f.extension in ('cbr', 'cbz'):
            return self.app_comix(c)

        return DefaultApps.app_default(self, c)
