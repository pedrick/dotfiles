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

    device_info = subprocess.check_output(
        ['iw', 'dev', device, 'link']).decode('utf8')
    strength = 0
    ssid = None
    for line in device_info.split('\n'):
        if 'SSID' in line:
            fields = line.strip().split(':')
            ssid = fields[1].strip()
        if 'signal' in line:
            dbm_string = line.strip().split()[1]
            dbm = int(dbm_string)
            strength = 2 * (dbm + 100)

    if strength > 85:
        strength_color = SolarizedColors.green
    elif strength > 50:
        strength_color = SolarizedColors.yellow
    else:
        strength_color = SolarizedColors.red

    print('%s <fc=%s>%s%%</fc>' % (ssid, strength_color, strength))


if __name__ == '__main__':
    main()
