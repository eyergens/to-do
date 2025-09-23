import Sortable from "sortablejs";
import { getCSRFToken } from "../global";

$(function() {
  $('body').on('click', '.delete', function() {
    $('#' + $(this).data('id')).modal('show');
  });

  $('body').on('click', '.confirm-delete', function() {
    $('.modal').modal('hide');
  });

  let sortable = new Sortable(document.getElementById('active_list'), {handle: '.bi-list', forceFallback: true, onEnd: function(evt) {
    fetch('/items/reorder', {
        method: 'POST',
        mode: 'cors',
        cache: 'no-cache',
        credentials: 'same-origin',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': getCSRFToken()
        },
        body: JSON.stringify({ new_order: sortable.toArray() })
    })
    .then(response => response.json())
  }});
});