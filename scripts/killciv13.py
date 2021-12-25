# basically a modified copy of restartinactiveserver.py
import os
import signal

currdir = os.path.dirname(os.path.abspath(__file__))
lines = open(os.path.join(currdir,"paths.txt"))
all_lines = lines.readlines()

port = all_lines[3]
port = port.replace("\n", "")
port = port.replace("port:", "")


pids = [pid for pid in os.listdir('/proc') if pid.isdigit()]

for pid in pids:
	try:
		name = open(os.path.join('/proc', pid, 'cmdline'), 'r').read()
		if "civ13.dmb" in name and (port in name):
			os.kill(int(pid), signal.SIGKILL)
	except IOError:
		continue

handle = open(os.path.join(currdir, "token.txt"))
token = handle.read()
print("Запускаем...")
handle.close()

from discord import Webhook, RequestsWebhookAdapter

webhook = Webhook.from_url(token, adapter=RequestsWebhookAdapter())
webhook.send("<@&896361299057983519> сервер отключён")