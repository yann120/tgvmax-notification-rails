var options = {
    url: function (phrase) {
        if (phrase !== "") {
            return "http://localhost:3000/api/stations?q=" + phrase + "";
        } else {
            return "http://localhost:3000/api/stations?q=";
        }
    },

    getValue: "name",

    requestDelay: 300,

    theme: "round"
};

$("#trip_departure_station").easyAutocomplete(options);
$("#trip_arrival_station").easyAutocomplete(options);