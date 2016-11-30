$ ->
  accessToken = $('body').attr('data-access_token')

  App.interpreter = App.cable.subscriptions.create { channel: 'InterpreterChannel', access_token: accessToken },
    connected: ->
      # Called when the subscription is ready for use on the server

    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (params) ->
      if params['err']
        $('#output').addClass('alert alert-danger').html(params['err'])
      else
        $('#output').removeClass('alert alert-danger').html('')
        $("#diagram").attr('src', params['src'])

    interpret: (script) ->
      @perform 'interpret', script: script

$ ->
  timerId = null
  prevScript = null

  save = ->
      script = $('#script').val().replace(/\n+$/g,'').replace(/^\n+/g,'')

      if script == '' || script == prevScript
        return

      prevScript = script
      App.interpreter.interpret(script)

  $(document).on 'keydown keypress', '#script', ->
    clearTimeout(timerId) if timerId
    timerId = setTimeout(save, 800)
    true

  $('#script').focus()
