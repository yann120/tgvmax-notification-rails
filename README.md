# TGVMAX Notifications

## Database

### User
* email
* password
* tgvmax_key
* birthdate

### Trips : limit 5 per user
* traveler : user_id
* departure_station : string
* arrival_station : string
* from_date : datetime
* to_date : datetime
* searching : boolean


## TODO
* TGVMAX Key validator
* Birthdate < 28 years
* validate futur date only