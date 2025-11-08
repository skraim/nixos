#!/usr/bin/env python3

from dbus_next.aio import MessageBus
from dbus_next.constants import BusType
from dbus_next.errors import DBusError
import asyncio
import sys

BLUEZ = "org.bluez"
BLUEZ_PATH = "/org/bluez/hci0/"
GATT_SERVICE = 'org.bluez.GattService1'
GATT_CHARACTERISCITC = 'org.bluez.GattCharacteristic1'
GATT_CHARACTERISCITC_DESCR = 'org.bluez.GattDescriptor1'
BATTERY_UUID = "0000180f-0000-1000-8000-00805f9b34fb"
BATTERY_LEVEL_UUID = "00002a19-0000-1000-8000-00805f9b34fb"
BATTERY_USER_DESC = "00002901-0000-1000-8000-00805f9b34fb"


if sys.version_info >= (3, 10):
    try:
        loop = asyncio.get_running_loop()
    except RuntimeError:
        loop = asyncio.new_event_loop()
        asyncio.set_event_loop(loop)
else:
    loop = asyncio.get_event_loop()


async def retriev_levels(address):
    btAdapterAddr = address.replace(':', '_')
    BLUEZ_DEVICE_PATH = BLUEZ_PATH+"dev_{}".format(btAdapterAddr)

    bus = await MessageBus(bus_type=BusType.SYSTEM).connect()
    # the introspection xml would normally be included in your project, but
    # this is convenient for development
    introspection = await bus.introspect(BLUEZ, BLUEZ_DEVICE_PATH)

    device = bus.get_proxy_object(BLUEZ, BLUEZ_DEVICE_PATH, introspection)

    levels = []

    for svc in device.child_paths:
        intp = await bus.introspect(BLUEZ, svc)
        proxy = bus.get_proxy_object(BLUEZ, svc, intp)
        intf = proxy.get_interface(GATT_SERVICE)
        if BATTERY_UUID == await intf.get_uuid():
            for char in proxy.child_paths:
                intp = await bus.introspect(BLUEZ, char)
                proxy = bus.get_proxy_object(BLUEZ, char, intp)
                intf = proxy.get_interface(GATT_CHARACTERISCITC)
                level = int.from_bytes(await intf.call_read_value({}), byteorder='big')
                levels.append(level)
    return levels

async def main():
    # TODO: fix hardcode
    # address = sys.argv[1:]
    address = "CB:3B:8C:0D:E9:FC"
    
    print("  ", end="")

    levels = []

    try:
        levels = await retriev_levels(address)
    except DBusError as e:
        print(e)
        print("x")
    except:
        print("error")
    else:
        print(" / ".join([f"{x}%" for x in levels]))

loop.run_until_complete(main())
