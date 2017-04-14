//= require jquery.countTo
//
// Check for signature count update every 12 seconds
(function ($) {
  'use strict';

  var JSON_URL = '/en/signatures/counts.json',
      COUNTRY_CODES = $("[data-country]").map(function() {
                        return $(this).data("country");
                      }).get(),
      TIMEOUT = 12000,
      DELIMITER = $("[data-delimiter]").data('delimiter');

  function add_delimiters(n) {
    return n.toFixed(0).replace(/\B(?=(\d{3})+(?!\d))/g, DELIMITER);
  }

  function fetch_count() {
    $.get(JSON_URL, { countries: COUNTRY_CODES.join(',') }, function(data) {
      if (data) {
        $.each(COUNTRY_CODES, function( index, value ) {
          var $count = $("[data-country='" + value + "']");
          var sigs = data[value],
              current = parseInt($count.data('count'));
          if (sigs && sigs != current) {
            $count.data('count', data[value]);
            $count.countTo({
              from: current,
              to: sigs,
              refreshInterval: 50,
              formatter: add_delimiters
            });
          }
        });
      }
      setTimeout(fetch_count, TIMEOUT);
    });
  }
  setTimeout(fetch_count, 1000);

})(jQuery);
