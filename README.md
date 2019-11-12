# TGVMAX Notifications

## Database

### User

- email
- password
- tgvmax_key
- birthdate

### Trips : limit 5 per user

- traveler : user_id
- departure_station : string
- arrival_station : string
- from_date : datetime
- to_date : datetime
- searching : boolean

## TODO

- Tester Sidekiq-cron sur Heroku
- Enlever boucle recherche trainline
- Implementer bot Trainline sur Sidekiq
https://medium.com/binar-academy/how-to-schedulling-using-sidekiq-cron-on-ruby-on-rails-c9bb321affeb


## Resources :

- https://medium.com/@davidsherline/dry-your-rails-code-with-singleton-class-methods-and-metaprogramming-9f37d3dd1c85 => Reutiliser une instance de classe, pour pas instancier le service train a chaque fois
- https://github.com/tonytonyjan/jaro_winkler => pour faire une recherche avec fautes de frappe. Remplace grep sur station list ?
- Changement de type d'inputs sur simple form https://github.com/plataformatec/simple_form#available-input-types-and-defaults-for-each-column-type
