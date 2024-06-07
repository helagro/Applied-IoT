from pytradfri import Gateway
from pytradfri.api.libcoap_api import APIFactory
from pytradfri.error import PytradfriError
from pytradfri.util import load_json, save_json
import uuid
import os

class Tradfri:
    CREDENTIALS_PATH = "generated_tradfri_credentials.json"
    GATEWAY_ADDR = os.environ.get("TRADFRI_GATEWAY_ADDR")

    api = None
    gateway = None


    def setupAPI(self, apiFactory: APIFactory):
        self.api = apiFactory.request
        self.gateway = Gateway()

    # ----------------------- AUTHENTICATE ----------------------- #

    def authWithKey(self, key: str):
        identity = uuid.uuid4().hex
        apiFactory = APIFactory(host=self.GATEWAY_ADDR, psk_id=identity)

        try:
            psk = apiFactory.generate_psk(key)
            save_json(self.CREDENTIALS_PATH, {"identity": identity, "key": psk})
            self.setupAPI(apiFactory)
        except AttributeError:
            raise PytradfriError("E-2: Invalid key")


    def askForKey(self):
        print(
            "Please provide the Security Code on the back of your gateway:",
            end=" ",
        )
        key = input().strip()

        while len(key) != 16:
            print("Invalid 'Security Code' provided, try again: ", end=" ")
            key = input().strip()
        
        return key


    def authWithGeneratedCredentials(self):
        conf = load_json(self.CREDENTIALS_PATH)

        try:
            api_factory = APIFactory(host=self.GATEWAY_ADDR, psk_id=conf["identity"], psk=conf["key"])
            self.setupAPI(api_factory)
            return True

        except KeyError: 
            return False

    # --------------------------- INIT --------------------------- #

    def __init__(self):
        success = self.authWithGeneratedCredentials()
        if not success:
            key = self.askForKey()
            self.authWithKey(key)