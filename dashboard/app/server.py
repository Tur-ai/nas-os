#!/usr/bin/env python3
"""NAS-OS Control Deck: server dashboard (hanya library standar Python, tanpa pip)."""
import glob, json, os, socket, subprocess, threading, time
from http.server import ThreadingHTTPServer, BaseHTTPRequestHandler

HERE = os.path.dirname(os.path.abspath(__file__))
PORT = int(os.environ.get("NAS_DASH_PORT", "80"))
SERVICES = [("Samba", "smbd"), ("Jellyfin", "jellyfin"), ("mDNS", "avahi-daemon"),
            ("Firewall", "ufw"), ("Fail2ban", "fail2ban"), ("Cockpit", "cockpit.socket"),
            ("Backup", "nas-backup.timer")]
HIST = 60
S = {"cpu": 0, "net": {"rx": 0, "tx": 0}, "services": [], "ip": "-", "backup": None,
     "hist": {"cpu": [], "rx": [], "tx": []}}

def read(p, d=""):
    try:
        with open(p) as f: return f.read()
    except OSError: return d

def cpu_times():
    v = list(map(int, read("/proc/stat").split("\n")[0].split()[1:]))
    return sum(v), v[3] + v[4]

def net_bytes():
    rx = tx = 0
    for l in read("/proc/net/dev").split("\n")[2:]:
        if ":" not in l: continue
        n, d = l.split(":", 1)
        if n.strip() == "lo": continue
        f = d.split(); rx += int(f[0]); tx += int(f[8])
    return rx, tx

def meminfo():
    m = {}
    for l in read("/proc/meminfo").split("\n"):
        if ":" in l:
            k, v = l.split(":"); m[k] = int(v.split()[0]) * 1024
    t = m.get("MemTotal", 1)
    return {"total": t, "used": t - m.get("MemAvailable", 0),
            "swap_total": m.get("SwapTotal", 0), "swap_used": m.get("SwapTotal", 0) - m.get("SwapFree", 0)}

def disk(path):
    try:
        s = os.statvfs(path); t = s.f_blocks * s.f_frsize
        return {"path": path, "total": t, "used": t - s.f_bavail * s.f_frsize}
    except OSError: return None

def svc(unit):
    try:
        return subprocess.run(["systemctl", "is-active", unit], capture_output=True, text=True, timeout=3).stdout.strip()
    except Exception: return "unknown"

def temp():
    ts = [int(read(p, "0").strip() or 0) for p in glob.glob("/sys/class/thermal/thermal_zone*/temp")]
    return round(max(ts) / 1000, 1) if ts and max(ts) > 0 else None

def get_ip():
    try: return subprocess.run(["hostname", "-I"], capture_output=True, text=True, timeout=2).stdout.split()[0]
    except Exception: return "127.0.0.1"

def last_backup():
    d = sorted(glob.glob("/srv/backup/20*"))
    return {"name": os.path.basename(d[-1]), "count": len(d)} if d else None

def push(k, v):
    h = S["hist"][k]; h.append(v); del h[:-HIST]

def sampler():
    t0, i0 = cpu_times(); rx0, tx0 = net_bytes(); n = 0
    while True:
        time.sleep(1); n += 1
        t1, i1 = cpu_times(); rx1, tx1 = net_bytes()
        cpu = round(100 * (1 - (i1 - i0) / ((t1 - t0) or 1)), 1)
        t0, i0 = t1, i1
        rx, tx = rx1 - rx0, tx1 - tx0; rx0, tx0 = rx1, tx1
        S["cpu"] = cpu; S["net"] = {"rx": rx, "tx": tx}
        push("cpu", cpu); push("rx", rx); push("tx", tx)
        if n % 5 == 1:
            S["services"] = [{"name": a, "unit": u, "state": svc(u)} for a, u in SERVICES]
            S["ip"] = get_ip(); S["backup"] = last_backup()

def snapshot():
    osname = next((l.split("=", 1)[1].strip().strip('"') for l in read("/etc/os-release").split("\n")
                   if l.startswith("PRETTY_NAME")), "Linux")
    return {"cpu": S["cpu"], "net": S["net"], "hist": S["hist"], "services": S["services"],
            "ip": S["ip"], "backup": S["backup"], "mem": meminfo(),
            "disks": [x for x in (disk("/"), disk("/srv/nas")) if x],
            "load": os.getloadavg(), "temp": temp(), "cores": os.cpu_count(),
            "uptime": float(read("/proc/uptime", "0").split()[0]), "host": socket.gethostname(),
            "kernel": os.uname().release, "os": osname}

class H(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path.startswith("/api/stats"):
            body, ct = json.dumps(snapshot()).encode(), "application/json"
        elif self.path in ("/", "/index.html"):
            with open(os.path.join(HERE, "index.html"), "rb") as f: body = f.read()
            ct = "text/html; charset=utf-8"
        else:
            self.send_error(404); return
        self.send_response(200)
        self.send_header("Content-Type", ct); self.send_header("Cache-Control", "no-store")
        self.send_header("Content-Length", str(len(body))); self.end_headers(); self.wfile.write(body)
    def log_message(self, *a): pass

if __name__ == "__main__":
    threading.Thread(target=sampler, daemon=True).start()
    ThreadingHTTPServer(("0.0.0.0", PORT), H).serve_forever()
