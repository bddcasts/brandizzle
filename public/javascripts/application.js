$(document).ready(function() {
  $("#filter-form select").change(function() {
    this.form.submit();
  });
})