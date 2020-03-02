import os
import sys
import shutil

for k in range(10,11):
    for i in range(24):
        for j in range(11):
            destination_file = f'/home/changming/data/vd/201801{k:02}/vd_value5_{i:02}{5*(j+1):02}.xml'
            source_file = f'/home/changming/data/vd/201801{k:02}/vd_value5_{i:02}{5*j:02}.xml'

            if os.path.exists(destination_file) == False:
                if os.path.exists(source_file) == True:
                    shutil.copyfile(source_file, destination_file)
        