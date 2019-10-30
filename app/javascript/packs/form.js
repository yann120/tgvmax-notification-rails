var options = {
    url: function (phrase) {
        if (phrase !== "") {
            return "https://www.trainline.fr/api/v5_1/stations?context=search&q=" + phrase + "";
        } else {
            //duckduckgo doesn't support empty strings
            return "https://www.trainline.fr/api/v5_1/stations?context=search&q=";
        }
    },

    getValue: "Text",

    ajaxSettings: {
        dataType: "jsonp"
    },

    listLocation: "RelatedTopics",

    requestDelay: 300,

    theme: "round"
};

$("#trip_departure_station").easyAutocomplete(options);