(function ($) {
  $("#signature_btn").click(function(event) {
    event.preventDefault();
    grecaptcha.execute();
  });
})(jQuery);

function onSubmit(token) {
  $(".sign-it-button").prop("disabled", true).addClass("active");
  document.getElementById("new_signature").submit();
}
