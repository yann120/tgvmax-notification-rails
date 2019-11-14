import trainline
import sys

if len(sys.argv) != 7:
    sys.exit("usage: python3 main.py birthdate tgvmax_key departure_station arrival_station from_date to_date\nexemple : python3 main.py 04/09/1992 HC123456789 Paris Nice '10/05/2019 08:00' '10/05/2019 21:00'")

birthdate = sys.argv[1]
tgvmax_key = sys.argv[2]
departure_station = sys.argv[3]
arrival_station = sys.argv[4]
from_date = sys.argv[5]
to_date = sys.argv[6]

User = trainline.Passenger(birthdate=birthdate)
User.add_special_card(trainline.TGVMAX, tgvmax_key)
results = trainline.search(
        passengers=[User],
        departure_station=departure_station,
        arrival_station=arrival_station,
        from_date=from_date,
        to_date=to_date,
        # max_price=1.0,
        transportation_mean='train')
print(results.csv())
