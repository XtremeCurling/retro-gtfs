# call this file to grab subway locations
from subway_api import get_incoming_trains
from vehicle import Vehicle
from fleet import Fleet
from time import sleep
import threading

# DEFINE THE SUBWAYS 
one = {
	'id':1,
	'stations':[ 'Sheppard West Station', 'Wilson Station', 'Yorkdale Station', 'Lawrence West Station', 'Glencairn Station', 'Eglinton West Station', 'St Clair West Station', 'Dupont Station', 'Spadina Station', 'St George Station',	'Museum Station', "Queen's Park Station", 'St Patrick Station', 'Osgoode Station', 'St Andrew Station', 'Union Station', 'King Station', 'Queen Station', 'Dundas Station', 'College Station', 'Wellesley Station', 'Bloor-Yonge Station', 'Rosedale Station', 'Summerhill Station', 'St Clair Station', 'Davisville Station', 'Eglinton Station', 'Lawrence Station', 'York Mills Station', 'Sheppard-Yonge Station', 'North York Centre Station', 'Finch Station' ]
}
two = {
	'id':2,
	'stations':[ 'Kipling Station', 'Islington Station', 'Royal York Station', 'Old Mill Station', 'Jane Station', 'Runnymede Station', 'High Park Station', 'Keele Station', 'Dundas West Station', 'Lansdowne Station', 'Dufferin Station', 'Ossington Station', 'Christie Station', 'Bathurst Station', 'Spadina Station', 'St George Station', 'Bay Station', 'Bloor-Yonge Station', 'Sherbourne Station', 'Castle Frank Station', 'Broadview Station', 'Chester Station', 'Pape Station', 'Donlands Station', 'Greenwood Station', 'Coxwell Station', 'Woodbine Station', 'Main Street Station', 'Victoria Park Station', 'Warden Station', 'Kennedy Station' ]
}
four = {
	'id':4,
	'dir':['West','East'],
	'stations':[ 'Sheppard-Yonge Station', 'Bayview Station', 'Bessarion Station', 'Leslie Station', 'Don Mills Station' ]
}

# create the fleet object 
fleet = Fleet()

# make the initial call for each station, getting everything as 
# quickly as possible
for stationName in four['stations']:
	print stationName
	# get status updates for all trains coming in to station
	updates = get_incoming_trains(stationName)
	for status in updates:
		fleet.take_update(status)


#print fleet.vehicles



