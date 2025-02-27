from influxdb_client import InfluxDBClient, Point
from influxdb_client.client.write_api import SYNCHRONOUS
from sensor import Sensor
import atexit

measurment = "sensor_data"
bucket = "main"
url = "http://influxdb:8086"
org = "se.helagro"

client = InfluxDBClient(
   url=url,
   org=org,
   token="does-not-matter-because-data-not-sensitive",
)

write_api = client.write_api(write_options=SYNCHRONOUS)
query_api = client.query_api()

def write(device_id: int, field_name: str, field_value) -> None:
    p = Point(measurment).tag("device", device_id).field(field_name, field_value)
    write_api.write(bucket=bucket, org=org, record=p)


def get_all_data() -> dict:
    query = f'from(bucket:"{bucket}")\
        |> range(start: -24h)\
        |> filter(fn:(r) => r._measurement == "{measurment}")'
    return get_data(query)


def get_data_by_device(device_id: int) -> dict:
    query = f'from(bucket:"{bucket}")\
        |> range(start: -24h)\
        |> filter(fn:(r) => r._measurement == "{measurment}") \
        |> filter(fn:(r) => r.device == "{device_id}")'
    return get_data(query)


def get_data(query: str) -> dict:
    result = query_api.query(org=org, query=query)
    results = {sensor.value: {} for sensor in Sensor}

    for table in result:
        for record in table.records:
            timestamp_seconds = round(record.get_time().timestamp())
            results[record.get_field()][timestamp_seconds] = record.get_value()

    return results


def closeDB() -> None:
    client.close()

atexit.register(closeDB)