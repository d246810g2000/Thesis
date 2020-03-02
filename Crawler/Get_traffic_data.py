import pandas as pd   #pandas提供 Series 與 DataFrame 的資料結構
import numpy as np    #支持多維數組與矩陣運算
from xml.dom import minidom

def get_data(filename):
    dom = minidom.parse(filename)
    xml = dom.getElementsByTagName("Info")
    want_vdid = [b'nfbVD-N5-N-15.488-M',
                 b'nfbVD-N5-N-16.196-M',
                 b'nfbVD-N5-N-16.900-M-PS',
                 b'nfbVD-N5-N-17.608-M',
                 b'nfbVD-N5-N-18.313-M-PS',
                 b'nfbVD-N5-N-19.012-M',
                 b'nfbVD-N5-N-19.689-M-PS',
                 b'nfbVD-N5-N-20.412-M',
                 b'nfbVD-N5-N-21.055-M-PS',
                 b'nfbVD-N5-N-21.808-M',
                 b'nfbVD-N5-N-22.510-M-PS',
                 b'nfbVD-N5-N-23.209-M',
                 b'nfbVD-N5-N-23.911-M-PS',
                 b'nfbVD-N5-N-24.677-M',
                 b'nfbVD-N5-N-25.310-M-PS',
                 b'nfbVD-N5-N-26.007-M',
                 b'nfbVD-N5-N-26.705-M-PS',
                 b'nfbVD-N5-N-27.468-M',
                 b'nfbVD-N5-N-27.779-M',
                 b'nfbVD-N5-N-28.420-M',
                 b'nfbVD-N5-N-29.000-M',
                 b'nfbVD-N5-N-29.600-M',
                 b'nfbVD-N5-N-30.000-I-SN',
                 b'nfbVD-N5-N-30.100-M']
    dataset = []
    for i in range(len(xml)):
        data = {}
        vdid = xml[i].attributes['vdid'].value
        status = xml[i].attributes['status'].value
        data['vdid'] = vdid.encode('utf-8')
        data['status'] = int(status)
        lanes = xml[i].getElementsByTagName('lane')
        lane = []
        for j in range(len(lanes)):
            lane_data = {} 
            vsrid = lanes[j].attributes['vsrid'].value
            speed = lanes[j].attributes['speed'].value
            laneoccupy = lanes[j].attributes['laneoccupy'].value
            lane_data['vsrid'] = int(vsrid)
            lane_data['speed'] = int(speed)
            lane_data['laneoccupy'] = int(laneoccupy)
            lane_data['cars'] = []
            lane.append(lane_data)
            cars = lanes[j].getElementsByTagName('cars')
            car = {}
            for k in range(len(cars)):
                carid = cars[k].attributes['carid'].value
                volume = cars[k].attributes['volume'].value
                car = {'carid':carid.encode('utf-8'), 'volume':int(volume)} 
                lane_data['cars'].append(car)
        data['lane'] = lane
        for j in range(len(want_vdid)):
            if want_vdid[j] == data['vdid']:
                dataset.append(data)
    return(dataset)

data = []
for i in range(24):
    for j in range(12):
        filepath = 'C:/pythonwork/TrafficFlow/data/20180201/vd_value5_'"{:02}{:02}"'.xml'.format(i,5*j)
        data.append(get_data(filepath))

total = []
for j in range(len(data[0])):
    flow = []
    speed = []
    laneoccupy = []
    for i in range(len(data)):
        if data[i] != []:
            flow.append((data[i][j]['lane'][0]['cars'][0]['volume']*1 + data[i][j]['lane'][0]['cars'][1]['volume']*1.5 + data[i][j]['lane'][0]['cars'][2]['volume']*2) * 12)
            speed.append(data[i][j]['lane'][0]['speed'])
            laneoccupy.append(data[i][j]['lane'][0]['laneoccupy'])
        else:
            flow.append(np.nan)
            speed.append(np.nan)
            laneoccupy.append(np.nan)
    total.append([flow, speed, laneoccupy])

total_flow = []
total_speed = []
total_laneoccupy = []
for i in range(len(total)):
    total_flow.append(total[i][0])
    total_speed.append(total[i][1])
    total_laneoccupy.append(total[i][2])

data_flow = pd.DataFrame(total_flow).T
data_speed = pd.DataFrame(total_speed).T
data_laneoccupy = pd.DataFrame(total_laneoccupy).T
data_flow.index = pd.Index(pd.date_range('2/1/2018 00:00', periods=288, freq='5MIN'))
data_speed.index = pd.Index(pd.date_range('2/1/2018 00:00', periods=288, freq='5MIN'))
data_laneoccupy.index = pd.Index(pd.date_range('2/1/2018 00:00', periods=288, freq='5MIN'))

# 尋找負值，並補成缺失值。
data_flow[data_flow < 0] = np.nan
data_speed[data_speed < 0] = np.nan
data_laneoccupy[data_laneoccupy < 0] = np.nan

# 尋找缺失值，並補前一個值，若還有缺失值則補後一個值。
data_flow = data_flow.fillna(method="ffill")
data_flow = data_flow.fillna(method="bfill")
data_speed = data_speed.fillna(method="ffill")
data_speed = data_speed.fillna(method="bfill")
data_laneoccupy = data_laneoccupy.fillna(method="ffill")
data_laneoccupy = data_laneoccupy.fillna(method="bfill")

# 存成csv檔
data_flow.to_csv('C:/Users/User/Documents/論文研究/data/20180201_flow.csv', mode='a', index=True, header = True)
data_speed.to_csv('C:/Users/User/Documents/論文研究/data/20180201_speed.csv', mode='a', index=True, header = True)
data_laneoccupy.to_csv('C:/Users/User/Documents/論文研究/data/20180201_laneoccupy.csv', mode='a', index=True, header = True)