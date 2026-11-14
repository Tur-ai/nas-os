#!/usr/bin/env python3
"""Dashboard teks untuk layar fisik (tty1). Membaca data dari server.py."""
import json, os, time, urllib.request
URL = f"http://127.0.0.1:{os.environ.get('NAS_DASH_PORT', '80')}/api/stats"
C = lambda n, t: f"\033[{n}m{t}\033[0m"
BANNER = r"""
 _   _    _    ____        ___  ____
| \ | |  / \  / ___|      / _ \/ ___|
|  \| | / _ \ \___ \ ____| | | \___ \
| |\  |/ ___ \ ___) |____| |_| |___) |
|_| \_/_/   \_\____/      \___/|____/"""
gb = lambda b: f"{b / 2**30:.1f} GB"

def bar(p, w=32):
    p = max(0, min(100, p)); f = int(w * p / 100)
    col = 36 if p < 60 else 33 if p < 85 else 31
    return C(col, "█" * f) + C(90, "░" * (w - f)) + f" {p:5.1f}%"

def main():
    while True:
        try: d = json.load(urllib.request.urlopen(URL, timeout=2))
        except Exception:
            print("\033[H\033[JMenunggu dashboard..."); time.sleep(2); continue
        m = d["mem"]; up = d["uptime"]
        o = ["\033[H\033[J" + C("1;36", BANNER), ""]
        o.append(f" {C(90,'Host')} {d['host']}   {C(90,'IP')} {C('1;32', d['ip'])}   {C(90,'Web')} {C('1;35', 'http://' + d['ip'])}")
        o.append(f" {C(90,'Jellyfin')} :8096   {C(90,'Cockpit')} :9090   {C(90,'Uptime')} {int(up//3600)}j {int(up%3600//60)}m\n")
        o.append(f" CPU   {bar(d['cpu'])}   load {d['load'][0]:.2f}")
        o.append(f" RAM   {bar(100*m['used']/m['total'])}   {gb(m['used'])} / {gb(m['total'])}")
        for k in d["disks"]:
            o.append(f" {k['path']:<5} {bar(100*k['used']/max(k['total'],1))}   {gb(k['used'])} / {gb(k['total'])}")
        o.append("")
        o.append(" " + "  ".join((C(32, "●") if s["state"] == "active" else C(31, "●")) + " " + s["name"] for s in d["services"]))
        b = d["backup"]
        o.append("\n " + C(90, "Backup terakhir") + " " + (f"{b['name']} ({b['count']} snapshot)" if b else "belum ada"))
        print("\n".join(o), flush=True); time.sleep(2)

if __name__ == "__main__":
    try: main()
    except KeyboardInterrupt: pass
