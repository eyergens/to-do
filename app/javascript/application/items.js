$(function() {
  $('body').on('click', '.delete', function() {
    $('#' + $(this).data('id')).modal('show');
  });

  $('body').on('click', '.confirm-delete', function() {
    $('.modal').modal('hide');
  });
});