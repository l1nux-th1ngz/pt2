#!/usr/bin/python3
#coding: utf-8

import re
import sys
import subprocess

def get_ttl(ip_address):
    try:
        proc = subprocess.Popen(["ping", "-c", "1", ip_address], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out, err = proc.communicate()
        out = out.decode('utf-8')

        ttl_value = re.search(r"ttl=(\d+)", out).group(1)
        return ttl_value
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

def get_os(ttl):
    ttl = int(ttl)

    if ttl >= 0 and ttl <= 64:
        return "Linux"
    elif ttl >= 65 and ttl <= 128:
        return "Windows"
    elif ttl >= 129 and ttl <= 255:
        return "macOS"
    else:
        return "Not Found"

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print(f"\n[!] Usage: python3 {sys.argv[0]} <ip-address>\n")
        sys.exit(1)

    ip_address = sys.argv[1]

    ttl = get_ttl(ip_address)
    os_name = get_os(ttl)
    
    print(f"\n\t{ip_address} (ttl -> {ttl}): {os_name}")
