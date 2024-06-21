from influxdb_client import BucketRetentionRules, InfluxDBClient, Point
from influxdb_client.client.write_api import SYNCHRONOUS

bucket = "main"
url = "http://localhost:8086"
org = "se.helagro"
retention_rules = BucketRetentionRules(type="expire", every_seconds=3600)

client = InfluxDBClient(
   url=url,
   org=org,
   password="doesNotMatter",
   username="helagro"
)

write_api = client.write_api(write_options=SYNCHRONOUS)

p = Point("my_measurement").tag("location", "Prague").field("temperature", 25.3)
write_api.write(bucket=bucket, record=p)

query_api = client.query_api()
query = 'from(bucket:"main")\
|> range(start: -10m)\
|> filter(fn:(r) => r._measurement == "my_measurement")\
|> filter(fn:(r) => r.location == "Prague")\
|> filter(fn:(r) => r._field == "temperature")'

result = query_api.query(org=org, query=query)
print(result)
