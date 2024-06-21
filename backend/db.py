from influxdb_client import InfluxDBClient, Point
from influxdb_client.client.write_api import SYNCHRONOUS
from sensor import Sensor
import json
import datetime

measurment = "sensor_data"
bucket = "main"
url = "http://localhost:8086"
org = "se.helagro"

client = InfluxDBClient(
   url=url,
   org=org,
   username="helagro",
   password="doesNotMatter"
)

write_api = client.write_api(write_options=SYNCHRONOUS)
query_api = client.query_api()

def write(device_id: int, field_name: str, field_value) -> None:
    p = Point(measurment).tag("device", device_id).field(field_name, field_value)
    write_api.write(bucket=bucket, org=org,record=p)


def get_all_data():
    query = f'from(bucket:"{bucket}")\
        |> range(start: -1w)\
        |> filter(fn:(r) => r._measurement == "{measurment}")'
    result = query_api.query(org=org, query=query)
    results = {sensor.value: {} for sensor in Sensor}

    for table in result:
        for record in table.records:
            results[record.get_field()][record.get_time().total_seconds()] = record.get_value()

    print(json.dumps(results, indent=4))


read = input("Enter field value: ")

while read != "exit":
    write(0, "light", float(read))
    get_all_data()
    read = input("Enter field value: ")

client.close()
