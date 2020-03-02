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
                 b'nfbVD-N5-N-30.000-I-EN',
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
        for l in range(len(want_vdid)):
            if want_vdid[l] == data['vdid']:
                dataset.append(data)
    return(dataset)

for m in range(1,32):
    data = []
    for n in range(24):
        for k in range(12):
            filepath = f"/home/changming/data/vd/201805{m:02}/vd_value5_{n:02}{5*k:02}.xml"
            print(filepath)
            data.append(get_data(filepath))

    total = []
    for p in range(len(data[0])):
        flow = []
        speed = []
        laneoccupy = []
        for o in range(len(data)):
            if data[o] != []:
                flow.append((data[o][p]['lane'][0]['cars'][0]['volume']*1 + data[o][p]['lane'][0]['cars'][1]['volume']*1.5 + data[o][p]['lane'][0]['cars'][2]['volume']*2) * 12)
                speed.append(data[o][p]['lane'][0]['speed'])
                laneoccupy.append(data[o][p]['lane'][0]['laneoccupy'])
            else:
                flow.append(np.nan)
                speed.append(np.nan)
                laneoccupy.append(np.nan)
        total.append([flow, speed, laneoccupy])

    total_flow = []
    total_speed = []
    total_laneoccupy = []
    for q in range(len(total)):
        total_flow.append(total[q][0])
        total_speed.append(total[q][1])
        total_laneoccupy.append(total[q][2])

    data_flow = pd.DataFrame(total_flow).T
    data_speed = pd.DataFrame(total_speed).T
    data_laneoccupy = pd.DataFrame(total_laneoccupy).T
    data_flow.index = pd.Index(pd.date_range(f'05/{m:02}/2018 00:00', periods=288, freq='5MIN'))
    data_speed.index = pd.Index(pd.date_range(f'05/{m:02}/2018 00:00', periods=288, freq='5MIN'))
    data_laneoccupy.index = pd.Index(pd.date_range(f'05/{m:02}/2018 00:00', periods=288, freq='5MIN'))

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
    data_flow.to_csv(f'/home/changming/data/csv/flow/201805{m:02}_flow.csv', mode='a', index=True, header = True)
    data_speed.to_csv(f'/home/changming/data/csv/speed/201805{m:02}_speed.csv', mode='a', index=True, header = True)
    data_laneoccupy.to_csv(f'/home/changming/data/csv/laneoccupy/201805{m:02}_laneoccupy.csv', mode='a', index=True, header = True)
    print(f'201805{m:02} has been converted to data')
    print('-----------------------------------------')