import urllib.request
import os

for h in range(7,13):
	for k in range(1,32):
		path = f"/home/changming/data/vd/2018{h:02}{k:02}"
		if not os.path.isdir(path):
			os.mkdir(path)

		for i in range(24):
			for j in range(12):
				url = f"http://tisvcloud.freeway.gov.tw/history/vd/2018{h:02}{k:02}/vd_value5_{i:02}{5*j:02}.xml.gz"
				filepath = f"/home/changming/data/vd/2018{h:02}{k:02}/vd_value5_{i:02}{5*j:02}.xml.gz"
				if not os.path.isfile(filepath):
					result = urllib.request.urlretrieve(url, filepath)
					print("downloaded:", result)