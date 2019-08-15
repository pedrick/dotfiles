#!/usr/bin/env python
import subprocess


class SolarizedColors:
    red = "#de935f"
    yellow = "#b58900"
    green = "#859900"


def _get_device():
    links = subprocess.check_output(['ip', 'link']).decode('utf8')

    for link in links.split('\n'):
        if 'state UP' not in link:
            continue
        fields = link.split()
        device = fields[1][:-1]
        return device


def main():
    device = _get_device()

    if device is None:
        print("<fc=%s>Not connected</fc>" % SolarizedColors.yellow)
        return

    if device.startswith('en'):
        print('Wired')
        return

    device_info = subprocess.check_output(['iwconfig', device]).decode('utf8')
    strength = None
    essid = None
    for line in device_info.split('\n'):
        if 'ESSID' in line:
            fields = line.split(' ', 2)
            essid_field = fields[2].strip()
            # Select section between double quotes.
            essid = essid_field[essid_field.find('"') + 1:-1]
        if 'Link Quality' in line:
            strength_string = line.split('=')[1].split()[0]
            num, denom = map(float, strength_string.split('/'))
            strength = int(num / denom * 100)

    if strength > 85:
        strength_color = SolarizedColors.green
    elif strength > 50:
        strength_color = SolarizedColors.yellow
    else:
        strength_color = SolarizedColors.red

    print('%s <fc=%s>%s%%</fc>' % (essid, strength_color, strength))


if __name__ == '__main__':
    main()
