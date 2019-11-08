var options = {
    url: function (phrase) {
        if (phrase !== "") {
            return "/api/stations?q=" + phrase + "";
        } else {
            return "/api/stations?q=";
        }
    },

    getValue: "name",

    requestDelay: 300,

    theme: "round"
};

$("#trip_departure_station").easyAutocomplete(options);
$("#trip_arrival_station").easyAutocomplete(options);
