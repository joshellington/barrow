
$ ->
  $('.refresh').on 'click', (e) ->
    $.post '/api/update', {delta: {users: [$(e.target).attr('data-uid')]}}, (d) ->
      console.log d

    e.preventDefault()