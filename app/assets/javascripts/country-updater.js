//= require jquery.countTo
//
// Check for signature count update every 12 seconds
(function ($) {
  'use strict';

  var COUNTRY_CODE = $('[data-country]').data('country'),
      JSON_URL = '/en/countries/' + COUNTRY_CODE.toLowerCase() + '/signature_counts.json',
      TIMEOUT = 12000,
      DELIMITER = $("[data-delimiter]").data('delimiter');

  function add_delimiters(n) {
    return n.toFixed(0).replace(/\B(?=(\d{3})+(?!\d))/g, DELIMITER);
  }

  function fetch_count() {
    $.get(JSON_URL, function(data) {
      if (data) {
        var $count = $("[data-country='" + COUNTRY_CODE + "']");
        var sigs = data.total,
            current = parseInt($count.data('count'));
        update_count($count, current, sigs);

        remove_bumped_places(data.places);

        var index = 1;
        $.each(data.places, function(place, count) {
          var $place_count = $("[data-place='" + place + "']");
          if ($place_count.length) {
            current = parseInt($place_count.data('count'));
            update_count($place_count, current, count);
          }
          else {
            var $elem = $('.new-row'),
                $clone = $elem.clone(true).removeClass('new-row hidden');
            $clone.find(':first-child').text(place);
            $clone.find(':nth-child(2)').attr('data-place', place);
            $(".signature-places div:nth-child(" + index + ")").before($clone.fadeIn('slow'));
            update_count($clone.find(':nth-child(2)'), 0, count);
          }
          index += 1;
        });
      }
      setTimeout(fetch_count, TIMEOUT);
    });
  }

  function update_count(node, current_count, new_count) {
    if (new_count && new_count != current_count) {
      node.data('count', new_count);
      node.countTo({
        from: current_count,
        to: new_count,
        refreshInterval: 50,
        formatter: add_delimiters
      });
    }
  }

  function remove_bumped_places(places) {
    $("[data-place]").each(function() {
      var place = $(this).attr('data-place');
      if (place !== '' && typeof places[place] === 'undefined') {
        $(this).parent().remove();
      }
    });
  }

  setTimeout(fetch_count, 1000);
})(jQuery);
